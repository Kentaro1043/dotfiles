{
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  services.kdeconnect = {
    enable = true;
  };
}
