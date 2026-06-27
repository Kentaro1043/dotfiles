{
  config,
  pkgs,
  lib,
  ...
}: let
  grafanaTrapAuthorization =
    config.sops.secrets.codex-grafana-trap-authorization.path;
  codex =
    pkgs.runCommand "codex-with-grafana-trap-auth" {
      nativeBuildInputs = [pkgs.makeWrapper];
      meta.mainProgram = "codex";
    } ''
      mkdir -p $out/bin
      makeWrapper ${lib.getExe pkgs.llm-agents.codex} $out/bin/codex \
        --run 'if [ -r "${grafanaTrapAuthorization}" ]; then export CODEX_MCP_GRAFANA_TRAP_AUTHORIZATION="$(cat "${grafanaTrapAuthorization}")"; fi'
    '';
in {
  sops.secrets.codex-grafana-trap-authorization = {};

  programs.codex = {
    enable = true;
    package = codex;
  };
  home.activation.setupCodexConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $HOME/.codex
    $DRY_RUN_CMD rm -f $HOME/.codex/config.toml
    $DRY_RUN_CMD cp ${./codex-config.toml} $HOME/.codex/config.toml
    $DRY_RUN_CMD chmod 644 $HOME/.codex/config.toml
  '';
}
