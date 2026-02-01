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
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      eamodio.gitlens
      jnoortheen.nix-ide
    ];
  };
}
