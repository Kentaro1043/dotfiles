{
  pkgs,
  lib,
  ...
}: {
  programs.gemini-cli = {
    enable = true;
    package = pkgs.llm-agents.gemini-cli;
  };

  home.activation.setupGeminiSetting = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $HOME/.gemini
    $DRY_RUN_CMD rm -f $HOME/.gemini/settings.json
    $DRY_RUN_CMD cp ${./gemini-cli-settings.json} $HOME/.gemini/settings.json
    $DRY_RUN_CMD chmod 644 $HOME/.gemini/settings.json
  '';
}
