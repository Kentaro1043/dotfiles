{
  pkgs,
  lib,
  llmAgentPackages,
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
  vscodium =
    # https://github.com/continuedev/continue/issues/821#issuecomment-3227673526
    pkgs.unstable.vscodium.overrideAttrs (
      _final: prev: {
        preFixup =
          prev.preFixup
          + "gappsWrapperArgs+=( --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [pkgs.gcc.cc.lib]} )";
      }
    );
in
  lib.mkIf pkgs.stdenv.isLinux {
    home.packages = with pkgs; [
      # GUI apps
      llmAgentPackages.chatgpt
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
      vscodium
    ];
  }
