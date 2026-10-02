{
  config,
  pkgs,
  lib,
  inputs,
  llmAgentPackages,
  ...
}: let
  mcpConfig = (pkgs.formats.toml {}).generate "codex-mcp.toml" {
    mcp_servers = lib.mapAttrs (_: server:
      (lib.optionalAttrs (server.enabled != null) {inherit (server) enabled;})
      // (
        if server.command != null
        then {
          inherit (server) command args env;
          startup_timeout_sec = 60;
        }
        else {
          inherit (server) url;
          http_headers = server.headers;
        }
      ))
    config.programs.mcp.servers;
  };
  codexConfig = pkgs.runCommand "codex-config.toml" {} ''
    cat ${./codex-config.toml} > "$out"
    echo >> "$out"
    cat ${mcpConfig} >> "$out"
  '';
  codexHomes = [
    ".codex"
    ".codex-work"
  ];
  skills = import ./agent-skills.nix {inherit inputs;};
in {
  programs.codex = {
    enable = true;
    package = llmAgentPackages.codex;
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
    lib.concatMapStringsSep "\n" (codexHome: ''
      $DRY_RUN_CMD mkdir -p "$HOME/${codexHome}"
      if [ -z "$DRY_RUN_CMD" ]; then
        umask 077
        temporary="$(${pkgs.coreutils}/bin/mktemp "$HOME/${codexHome}/config.toml.XXXXXX")"
        ${pkgs.coreutils}/bin/cat ${codexConfig} > "$temporary"
        chmod 600 "$temporary"
        ${pkgs.coreutils}/bin/mv -f "$temporary" "$HOME/${codexHome}/config.toml"
      fi
    '')
    codexHomes
  );
}
