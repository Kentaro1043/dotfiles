{
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  home.activation.refreshPlasmaApplicationMenu = lib.hm.dag.entryAfter ["linkGeneration"] ''
    run ${lib.getExe' pkgs.kdePackages.kservice "kbuildsycoca6"} --noincremental
  '';
}
