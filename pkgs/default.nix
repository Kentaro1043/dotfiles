{inputs, ...}: pkgs: {
  codex-rs = inputs.codex.packages.${pkgs.system}.default;
  # codex-bin = pkgs.callPackage ./codex-bin.nix {};
}
