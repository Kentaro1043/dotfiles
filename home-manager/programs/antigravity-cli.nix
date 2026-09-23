{
  inputs,
  lib,
  pkgs,
  llmAgentPackages,
  ...
}: let
  skills = import ./agent-skills.nix {inherit inputs;};
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
    package = llmAgentPackages.antigravity-cli;
    inherit settings;
    enableMcpIntegration = true;
    context.AGENTS = ./AGENTS.md;
    skills = lib.listToAttrs (map (skill: lib.nameValuePair skill.name skill.source) skills);
  };
}
