{inputs, ...}: pkgs: {
  cua-driver = inputs.cua.packages.${pkgs.stdenv.hostPlatform.system}.cua-driver;
  flybywire-installer = pkgs.callPackage ./flybywire-installer.nix {};
  hermes-desktop = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.desktop;
  littlenavmap = pkgs.callPackage ./littlenavmap.nix {};
  mdx-cli = pkgs.callPackage ./mdx-cli.nix {src = inputs.mdx-cli;};
  zen-browser-bin = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
}
