{
  lib,
  pkgs,
  config,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux
{
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

          # Languages
          jnoortheen.nix-ide
          llvm-vs-code-extensions.vscode-clangd
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "qwen-code-vscode-ide-companion";
            publisher = "qwenlm";
            version = "0.9.0";
            sha256 = "sha256-x/1VTGaVvFytGc3p4PFOifP3PoIWMiDyuEyw0KhVH/g=";
          }
        ];
    };
  };
  # Runtime Config
  home.file.".vscode-oss/argv.json".source = ./vscode-argv.json;
}
