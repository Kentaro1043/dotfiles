{inputs, ...}: pkgs: {
  hermes-desktop = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.desktop;
  zen-browser-bin = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
}
