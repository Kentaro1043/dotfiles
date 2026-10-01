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
        "PATH=${lib.makeBinPath (with pkgs; [bash gh git nix nodejs uv])}:${config.home.profileDirectory}/bin:/run/current-system/sw/bin"
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
    lib.concatMapStringsSep "\n" (codexHome: ''
      $DRY_RUN_CMD mkdir -p "$HOME/${codexHome}"
      $DRY_RUN_CMD rm -f "$HOME/${codexHome}/config.toml"
      $DRY_RUN_CMD cp ${codexConfig} "$HOME/${codexHome}/config.toml"
      $DRY_RUN_CMD chmod 644 "$HOME/${codexHome}/config.toml"
    '')
    codexHomes
  );
}
