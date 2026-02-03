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
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Editor
        dracula-theme.theme-dracula
        eamodio.gitlens

        # AI
        continue.continue
        rooveterinaryinc.roo-cline

        # Languages
        jnoortheen.nix-ide
        llvm-vs-code-extensions.vscode-clangd
      ];
    };
  };
}
