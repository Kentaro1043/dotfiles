{inputs, ...}: pkgs: {
  cua-driver = inputs.cua.packages.${pkgs.stdenv.hostPlatform.system}.cua-driver;
  hermes-desktop = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.desktop;
  mdx-cli = pkgs.callPackage ./mdx-cli.nix {src = inputs.mdx-cli;};
  zen-browser-bin = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
}
