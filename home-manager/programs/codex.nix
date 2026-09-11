{
  config,
  pkgs,
  lib,
  inputs,
  llmAgentPackages,
  ...
}: let
  grafanaTrapAuthorization =
    config.sops.secrets.codex-grafana-trap-authorization.path;
  codex =
    pkgs.runCommand "codex-with-mcp-auth" {
      nativeBuildInputs = [pkgs.makeWrapper];
      meta.mainProgram = "codex";
    } ''
      mkdir -p $out/bin
      makeWrapper ${lib.getExe llmAgentPackages.codex} $out/bin/codex \
        --run 'if [ -r "${grafanaTrapAuthorization}" ]; then export CODEX_MCP_GRAFANA_TRAP_AUTHORIZATION="$(cat "${grafanaTrapAuthorization}")"; fi'
    '';
  codexHomes = [
    ".codex"
    ".codex-work"
  ];
  chatgptWorkInfo = pkgs.writeText "chatgpt-work-info.plist" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>CFBundleDisplayName</key>
      <string>ChatGPT(Work)</string>
      <key>CFBundleExecutable</key>
      <string>chatgpt-work-launcher</string>
      <key>CFBundleIconFile</key>
      <string>app.icns</string>
      <key>CFBundleIdentifier</key>
      <string>com.kentaro1043.chatgpt-work-launcher</string>
      <key>CFBundleName</key>
      <string>ChatGPT(Work)</string>
      <key>CFBundlePackageType</key>
      <string>APPL</string>
      <key>CFBundleShortVersionString</key>
      <string>1.0</string>
      <key>CFBundleVersion</key>
      <string>1</string>
      <key>LSUIElement</key>
      <true/>
      <key>NSHighResolutionCapable</key>
      <true/>
    </dict>
    </plist>
  '';
  chatgptWorkLauncher = pkgs.writeShellScript "chatgpt-work-launcher" ''
    codexWorkHome="$HOME/.codex-work"
    codexWorkUserData="$HOME/Library/Application Support/Codex Work"

    if [[ ! -d /Applications/ChatGPT.app ]]; then
      /usr/bin/osascript -e 'display alert "ChatGPT.appが見つかりません" message "/ApplicationsにChatGPTをインストールしてください。"'
      exit 1
    fi

    /bin/mkdir -p "$codexWorkHome"
    exec /usr/bin/open -n --env "CODEX_HOME=$codexWorkHome" \
      /Applications/ChatGPT.app \
      --args "--user-data-dir=$codexWorkUserData"
  '';
  chatgptWorkApp = pkgs.runCommand "chatgpt-work-app" {} ''
    mkdir -p "$out/Contents/MacOS" "$out/Contents/Resources"
    install -m 644 ${chatgptWorkInfo} "$out/Contents/Info.plist"
    install -m 755 ${chatgptWorkLauncher} \
      "$out/Contents/MacOS/chatgpt-work-launcher"
    ln -s /Applications/ChatGPT.app/Contents/Resources/app.icns \
      "$out/Contents/Resources/app.icns"
  '';
  skills = import ./agent-skills.nix {inherit inputs;};
in {
  sops.secrets.codex-grafana-trap-authorization = {};

  programs.codex = {
    enable = true;
    package = codex;
    context = ./AGENTS.md;
  };

  home.file =
    lib.listToAttrs (
      lib.concatMap (
        codexHome:
          map (skill:
            lib.nameValuePair "${codexHome}/skills/${skill.name}" {
              inherit (skill) source;
              force = true;
            })
          skills
      )
      codexHomes
    )
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      "Applications/ChatGPT(Work).app" = {
        source = chatgptWorkApp;
        force = true;
      };
    };

  home.activation.setupCodexConfig = lib.hm.dag.entryAfter ["writeBoundary"] (
    lib.concatMapStringsSep "\n" (codexHome: ''
      $DRY_RUN_CMD mkdir -p "$HOME/${codexHome}"
      $DRY_RUN_CMD rm -f "$HOME/${codexHome}/config.toml"
      $DRY_RUN_CMD cp ${./codex-config.toml} "$HOME/${codexHome}/config.toml"
      $DRY_RUN_CMD chmod 644 "$HOME/${codexHome}/config.toml"
    '')
    codexHomes
  );
}
