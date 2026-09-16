{
  lib,
  stdenvNoCC,
  fetchurl,
  buildFHSEnv,
  appimageTools,
  makeDesktopItem,
  writeShellScript,
}: let
  pname = "littlenavmap";
  version = "3.0.18";
  dist = stdenvNoCC.mkDerivation {
    pname = "${pname}-dist";
    inherit version;
    src = fetchurl {
      url = "https://github.com/albar965/littlenavmap/releases/download/v${version}/LittleNavmap-linux-ubuntu-24.04-${version}.tar.xz";
      hash = "sha256-fDGMNDUpCYl3NOHVz3Y0EHATjxZ4aGufGRqE0CaTxcM=";
    };
    dontBuild = true;
    dontFixup = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';
  };
  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Little Navmap";
    exec = pname;
    icon = pname;
    categories = ["Utility" "Geography"];
  };
in
  # Nixpkgs版はKDE Gear 5の廃止で削除されたため、公式バイナリを使う。
  buildFHSEnv (appimageTools.defaultFhsEnvArgs
    // {
      inherit pname version;
      runScript = writeShellScript "littlenavmap-start" ''
        unset QT_PLUGIN_PATH
        export QT_QPA_PLATFORM=xcb
        # 同梱DBをNixストアの読み取り専用属性を引き継がずに配置する。
        dbDir="''${XDG_CONFIG_HOME:-$HOME/.config}/ABarthel/little_navmap_db"
        mkdir -p "$dbDir"
        if [ ! -e "$dbDir/little_navmap_navigraph.sqlite" ]; then
          install -m644 ${dist}/little_navmap_db/little_navmap_navigraph.sqlite "$dbDir/"
        fi
        exec ${dist}/littlenavmap "$@"
      '';
      extraInstallCommands = ''
        install -Dm644 ${dist}/littlenavmap.svg $out/share/icons/hicolor/scalable/apps/littlenavmap.svg
        mkdir -p $out/share/applications
        cp ${desktopItem}/share/applications/* $out/share/applications/
      '';
      meta = {
        description = "Flight planner, navigation tool and moving map";
        homepage = "https://www.littlenavmap.org/";
        license = lib.licenses.gpl3Only;
        sourceProvenance = [lib.sourceTypes.binaryNativeCode];
        platforms = ["x86_64-linux"];
        mainProgram = pname;
      };
    })
