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
    unstable.jetbrains.pycharm
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
    usbutils
    wineWow64Packages.stable
    winetricks
    warp-terminal
    godot
    # rustdesk
    mission-center
    feishin
  ];
}
