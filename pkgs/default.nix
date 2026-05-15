{inputs, ...}: pkgs: {
  zen-browser-bin = inputs.zen-browser.packages.${pkgs.system}.default;
}
