{
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  programs.sagemath = {
    enable = true;
  };
}
