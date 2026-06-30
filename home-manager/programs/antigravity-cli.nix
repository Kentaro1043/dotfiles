{pkgs, ...}: let
  baseSettings = builtins.fromJSON (builtins.readFile ./antigravity-cli-settings.json);
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
in {
  programs.antigravity-cli = {
    enable = true;
    package = pkgs.llm-agents.gemini-cli;
    inherit settings;
  };

  home.file.".gemini/settings.json".force = true;
}
