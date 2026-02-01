{
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
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
      ];
    };
  };
}
