{
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      text-scaling-factor = 1.25;
    };
  };
}
