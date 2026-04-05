{inputs, ...}: pkgs: {
  codex-latest = inputs.codex.packages.${pkgs.system}.default;
  codex-bin = pkgs.callPackage ./codex-bin.nix {};

  opencode-latest = inputs.opencode.packages.${pkgs.system}.default;
}
