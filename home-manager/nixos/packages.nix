{
  pkgs,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux
{
  home.packages = with pkgs; [
    # GUI apps
    discord
    ghostty
  ];
}
