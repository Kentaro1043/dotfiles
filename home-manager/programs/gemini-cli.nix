{
  pkgs,
  lib,
  ...
}: let
  baseSettings = builtins.fromJSON (builtins.readFile ./gemini-cli-settings.json);
  darwinSettings =
    baseSettings
    // {
      tools =
        (baseSettings.tools or {})
        // {
          sandbox = "sandbox-exec";
          sandboxAllowedPaths = [
            "/Users/kentaro/.local/share/uv"
            "/Users/kentaro/.cache"
            "/Users/kentaro/.local/state"
            "/var/folders"
            "/private/var/folders"
            "/tmp"
            "/private/tmp"
          ];
        };
    };
  settings =
    if pkgs.stdenv.isDarwin
    then darwinSettings
    else baseSettings;
  settingsJson = pkgs.writeText "gemini-cli-settings.json" (builtins.toJSON settings);
in {
  programs.gemini-cli = {
    enable = true;
    package = pkgs.llm-agents.gemini-cli;
  };

  home.activation.setupGeminiSetting = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $HOME/.gemini
    $DRY_RUN_CMD cp ${settingsJson} $HOME/.gemini/settings.json
    $DRY_RUN_CMD chmod 644 $HOME/.gemini/settings.json
  '';
}
