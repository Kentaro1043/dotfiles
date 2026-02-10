{
  lib,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package =
      # https://github.com/continuedev/continue/issues/821#issuecomment-3227673526
      pkgs.vscodium.overrideAttrs (
        final: prev: {
          preFixup =
            prev.preFixup
            + "gappsWrapperArgs+=( --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [pkgs.gcc.cc.lib]} )";
        }
      );
    # Don't work
    #argvSettings = {
    #  "locale" = "ja";
    #};
    profiles.default = {
      userSettings = builtins.fromJSON (builtins.readFile ./vscode-settings.json);
      extensions = with pkgs.vscode-extensions;
        [
          # Editor
          dracula-theme.theme-dracula
          pkief.material-icon-theme
          eamodio.gitlens

          # AI
          continue.continue
          # rooveterinaryinc.roo-cline

          # Platform
          ms-kubernetes-tools.vscode-kubernetes-tools

          # Languages
          jnoortheen.nix-ide
          llvm-vs-code-extensions.vscode-clangd
          redhat.vscode-yaml
          redhat.ansible
          myriad-dreamin.tinymist
          golang.go
        ]
        ++ [
          pkgs.nix-vscode-extensions.vscode-marketplace.qwenlm.qwen-code-vscode-ide-companion
          pkgs.nix-vscode-extensions.vscode-marketplace.sst-dev.opencode
          pkgs.nix-vscode-extensions.vscode-marketplace.vivaxy.vscode-conventional-commits
          pkgs.nix-vscode-extensions.vscode-marketplace.jetpack-io.devbox
        ]
        ++ [
          pkgs.unstable.vscode-extensions.prettier.prettier-vscode # 2026-02-07現在、Unstableしかない
        ];
      enableExtensionUpdateCheck = false;
      enableMcpIntegration = true;
    };
  };
  # Runtime Config
  home.file.".vscode-oss/argv.json".source = ./vscode-argv.json;
}
