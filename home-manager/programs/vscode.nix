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
          eamodio.gitlens

          # AI
          continue.continue
          rooveterinaryinc.roo-cline

          # Platform
          ms-kubernetes-tools.vscode-kubernetes-tools

          # Languages
          jnoortheen.nix-ide
          llvm-vs-code-extensions.vscode-clangd
          redhat.vscode-yaml
        ]
        ++ [
          pkgs.unstable.vscode-extensions.prettier.prettier-vscode # 2026-02-07現在、Unstableしかない
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "qwen-code-vscode-ide-companion";
            publisher = "qwenlm";
            version = "0.9.1";
            sha256 = "sha256-zGFP2/xsiFIGJK8SMi39HRvrZWqCdWxvdwXJPLb4tSc=";
          }
          {
            name = "opencode";
            publisher = "sst-dev";
            version = "0.0.13";
            sha256 = "sha256-6adXUaoh/OP5yYItH3GAQ7GpupfmTGaxkKP6hYUMYNQ=";
          }
        ];
      enableExtensionUpdateCheck = false;
      enableMcpIntegration = true;
    };
  };
  # Runtime Config
  home.file.".vscode-oss/argv.json".source = ./vscode-argv.json;
}
