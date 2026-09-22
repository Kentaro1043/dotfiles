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
