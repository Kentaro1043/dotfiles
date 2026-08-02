{
  pkgs,
  lib,
  ...
}: let
  wrapJetBrainsIdeForXWayland = package: executable:
    pkgs.symlinkJoin {
      name = "${executable}-xwayland";
      paths = [package];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out/bin/${executable}" \
          --add-flags "-Dawt.toolkit.name=XToolkit"
      '';
    };
  ideaXWayland = wrapJetBrainsIdeForXWayland pkgs.unstable.jetbrains.idea "idea";
  pycharmXWayland = wrapJetBrainsIdeForXWayland pkgs.unstable.jetbrains.pycharm "pycharm";
in
  lib.mkIf pkgs.stdenv.isLinux {
    home.packages = with pkgs; [
      # GUI apps
      discord
      ghostty
      ideaXWayland
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
