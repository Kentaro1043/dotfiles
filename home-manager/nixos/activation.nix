{
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  home.activation.refreshPlasmaApplicationMenu = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${lib.getExe' pkgs.dbus "dbus-update-activation-environment"} --systemd XDG_DATA_DIRS PATH
    run ${lib.getExe' pkgs.kdePackages.kservice "kbuildsycoca6"} --noincremental
    run ${lib.getExe' pkgs.systemd "systemctl"} --user restart plasma-plasmashell.service
  '';
}
