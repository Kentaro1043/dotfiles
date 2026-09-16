{
  lib,
  appimageTools,
  fetchurl,
}: let
  pname = "flybywire-installer";
  version = "3.7.2";
  src = fetchurl {
    url = "https://github.com/flybywiresim/installer/releases/download/v${version}/FlyByWire-Installer-${version}-x86_64.AppImage";
    hash = "sha256-hg8gjyG8/qsjUR5UromyYcXAATN6gtlYBQdq7/+Z8BM=";
  };
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -Dm644 ${appimageContents}/fbw-installer.desktop \
        $out/share/applications/flybywire-installer.desktop
      substituteInPlace $out/share/applications/flybywire-installer.desktop \
        --replace-fail "Exec=AppRun" "Exec=flybywire-installer"
      mkdir -p $out/share/icons
      cp -r ${appimageContents}/usr/share/icons/hicolor $out/share/icons/
    '';

    meta = {
      description = "Installer for FlyByWire Simulations aircraft and tools";
      homepage = "https://flybywiresim.com/";
      license = lib.licenses.gpl3Only;
      platforms = ["x86_64-linux"];
      mainProgram = "flybywire-installer";
    };
  }
