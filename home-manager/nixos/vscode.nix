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
      jnoortheen.nix-ide
      dracula-theme.theme-dracula
    ];
  };
}
