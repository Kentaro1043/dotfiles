{
  pkgs,
  lib,
  ...
}: let
  pycharmXWayland = pkgs.symlinkJoin {
    name = "pycharm-xwayland";
    paths = [pkgs.unstable.jetbrains.pycharm];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram "$out/bin/pycharm" \
        --add-flags "-Dawt.toolkit.name=XToolkit"
    '';
  };
in
  lib.mkIf pkgs.stdenv.isLinux {
    home.packages = with pkgs; [
      # GUI apps
      discord
      ghostty
      pycharmXWayland
      rpi-imager
      libreoffice
      freelens-bin
      containerlab
      devpod-desktop
      mixxx
      qtcreator
      sidequest
      dbeaver-bin
      slack
      vlc
      woeusb-ng
      zen-browser-bin
      ardour
      zrythm
      surge-XT
      usbutils
      wineWow64Packages.stable
      winetricks
      warp-terminal
      godot
      # rustdesk
      mission-center
      feishin
      obs-studio
      shotcut
      hermes-desktop
      x42-avldrums
      chromium
    ];
  }
