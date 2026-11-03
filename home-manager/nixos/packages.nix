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
  ideaXWayland = wrapJetBrainsIdeForXWayland pkgs.unstable.intellij-idea "intellij-idea";
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
      # General
      discord
      libreoffice
      slack
      vlc
      winetricks
      # rustdesk
      obs-studio
      shotcut
      chromium
      brave
      spotify
      thunderbird

      # Development
      ghostty
      ideaXWayland
      pycharmXWayland
      rpi-imager
      freelens-bin
      containerlab
      devpod-desktop
      qtcreator
      dbeaver-bin
      woeusb-ng
      warp-terminal
      godot
      hermes-desktop
      vscodium
      github-desktop

      # LLM Agent
      llmAgentPackages.herdr-app
      llmAgentPackages.herdr-core
      llmAgentPackages.opencode2-desktop
      llmAgentPackages.orca
      llmAgentPackages.t3code-desktop

      # Game
      flybywire-installer
      littlenavmap
      protontricks
      sidequest

      # Music
      mixxx
      ardour
      zrythm
      surge-xt
      feishin
      x42-avldrums
      strawberry
      freac
      geonkick
    ];
  }
