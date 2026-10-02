{
  config,
  grafanaMcpCommands,
  pkgs,
  lib,
  inputs,
  llmAgentPackages,
  ...
}: let
  codexConfig = pkgs.writeText "codex-config.toml" (
    builtins.replaceStrings
    ["@grafanaWorkCommand@"]
    [grafanaMcpCommands.work]
    (builtins.readFile ./codex-config.toml)
  );
  grafanaTrapAuthorization = config.sops.secrets.grafana-mcp-trap-authorization.path;
  codex =
    pkgs.runCommand "codex-with-mcp-auth" {
      nativeBuildInputs = [pkgs.makeWrapper];
      meta.mainProgram = "codex";
    } ''
      mkdir -p $out/bin
      makeWrapper ${lib.getExe llmAgentPackages.codex} $out/bin/codex \
        --run 'if [ -r "${grafanaTrapAuthorization}" ]; then export GRAFANA_MCP_TRAP_AUTHORIZATION="$(${pkgs.coreutils}/bin/cat "${grafanaTrapAuthorization}")"; fi'
    '';
  codexHomes = [
    ".codex"
    ".codex-work"
  ];
  skills = import ./agent-skills.nix {inherit inputs;};
in {
  programs.codex = {
    enable = true;
    package = codex;
    context = ./AGENTS.md;
  };

  systemd.user.services.codex-app-server = lib.mkIf pkgs.stdenv.isLinux {
    Unit = {
      Description = "Codex App Server with Remote Control";
      After = ["sops-nix.service"];
      Wants = ["sops-nix.service"];
    };
    Install.WantedBy = ["default.target"];
    Service = {
      Type = "simple";
      WorkingDirectory = config.home.homeDirectory;
      Environment = [
        "CODEX_HOME=${config.home.homeDirectory}/.codex"
      ];
      ExecStart = "${lib.getExe config.programs.codex.package} app-server --remote-control --listen unix://";
      Restart = "on-failure";
      RestartSec = "5s";
      UMask = "0077";
    };
  };

  home.file = lib.listToAttrs (
    lib.concatMap (
      codexHome:
        map (skill:
          lib.nameValuePair "${codexHome}/skills/${skill.name}" {
            inherit (skill) source;
            force = true;
          })
        skills
    )
    codexHomes
  );

  home.activation.setupCodexConfig = lib.hm.dag.entryAfter ["writeBoundary"] (
    ''
      if [ -z "$DRY_RUN_CMD" ]; then
        token="$(SOPS_AGE_KEY_FILE=${lib.escapeShellArg config.sops.age.keyFile} \
          ${lib.getExe pkgs.sops} decrypt --extract '["joplin-api-token"]' \
          ${config.sops.defaultSopsFile})"
        case "$token" in
          ""|*[!0-9a-fA-F]*) echo "Invalid Joplin API token" >&2; exit 1 ;;
        esac
      fi
    ''
    + lib.concatMapStringsSep "\n" (codexHome: ''
      $DRY_RUN_CMD mkdir -p "$HOME/${codexHome}"
      if [ -z "$DRY_RUN_CMD" ]; then
        umask 077
        temporary="$(${pkgs.coreutils}/bin/mktemp "$HOME/${codexHome}/config.toml.XXXXXX")"
        ${pkgs.gnused}/bin/sed "s/@joplinToken@/$token/g" \
          ${codexConfig} > "$temporary"
        chmod 600 "$temporary"
        ${pkgs.coreutils}/bin/mv -f "$temporary" "$HOME/${codexHome}/config.toml"
      fi
    '')
    codexHomes
  );
}
