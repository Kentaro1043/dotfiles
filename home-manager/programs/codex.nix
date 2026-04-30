{
  pkgs,
  lib,
  ...
}: {
  programs.codex = {
    enable = true;
    package = pkgs.llm-agents.codex;
  };
  home.activation.setupCodexConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $HOME/.codex
    $DRY_RUN_CMD rm -f $HOME/.codex/config.toml
    $DRY_RUN_CMD cp ${./codex-config.toml} $HOME/.codex/config.toml
    $DRY_RUN_CMD chmod 644 $HOME/.codex/config.toml
  '';
}
