{
  config,
  pkgs,
  lib,
  inputs,
  llmAgentPackages,
  ...
}: let
  grafanaTrapAuthorization =
    config.sops.secrets.codex-grafana-trap-authorization.path;
  codex =
    pkgs.runCommand "codex-with-mcp-auth" {
      nativeBuildInputs = [pkgs.makeWrapper];
      meta.mainProgram = "codex";
    } ''
      mkdir -p $out/bin
      makeWrapper ${lib.getExe llmAgentPackages.codex} $out/bin/codex \
        --run 'if [ -r "${grafanaTrapAuthorization}" ]; then export CODEX_MCP_GRAFANA_TRAP_AUTHORIZATION="$(cat "${grafanaTrapAuthorization}")"; fi'
    '';
  codexHomes = [
    ".codex"
    ".codex-work"
  ];
  skills = import ./agent-skills.nix {inherit inputs;};
in {
  sops.secrets.codex-grafana-trap-authorization = {};

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
      $DRY_RUN_CMD cp ${./codex-config.toml} "$HOME/${codexHome}/config.toml"
      $DRY_RUN_CMD chmod 644 "$HOME/${codexHome}/config.toml"
    '')
    codexHomes
  );
}
