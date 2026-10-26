{inputs, ...}: pkgs: {
  cua-driver = inputs.cua.packages.${pkgs.stdenv.hostPlatform.system}.cua-driver;
  flybywire-installer = pkgs.callPackage ./flybywire-installer.nix {};
  hermes-desktop = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.desktop.override {
    extraEnv = {
      HERMES_DESKTOP_HERMES = "";
      HERMES_DESKTOP_IGNORE_EXISTING = "1";
    };
  };
  littlenavmap = pkgs.callPackage ./littlenavmap.nix {};
  mdx-cli = pkgs.callPackage ./mdx-cli.nix {src = inputs.mdx-cli;};
  zen-browser-bin = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
}
