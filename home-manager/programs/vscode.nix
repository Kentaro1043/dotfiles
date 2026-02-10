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
          pkgs.unstable.vscode-extensions.prettier.prettier-vscode # 2026-02-07現在、Unstableしかない
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "qwen-code-vscode-ide-companion";
            publisher = "qwenlm";
            version = "0.10.0";
            sha256 = "sha256-RHq5d/6xr9llhVnWjc1+1kZ6MnKJa3RrokC9+HqW5qk=";
          }
          {
            name = "opencode";
            publisher = "sst-dev";
            version = "0.0.13";
            sha256 = "sha256-6adXUaoh/OP5yYItH3GAQ7GpupfmTGaxkKP6hYUMYNQ=";
          }
          {
            name = "vscode-conventional-commits";
            publisher = "vivaxy";
            version = "1.27.0";
            sha256 = "sha256-yZ3pVBJGcwSNlN7LvFppAuNomxlQDTvA42kUpsZLj7Y=";
          }
          {
            name = "devbox";
            publisher = "jetpack-io";
            version = "0.1.8";
            sha256 = "sha256-2t18JIcjZT4+TDGPLGroLHujl9jtv0/DvOFKW0GNUc0=";
          }
        ];
      enableExtensionUpdateCheck = false;
      enableMcpIntegration = true;
    };
  };
  # Runtime Config
  home.file.".vscode-oss/argv.json".source = ./vscode-argv.json;
}
