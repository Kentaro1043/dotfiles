{pkgs, ...}: {
  home.packages = with pkgs; [
    # GUI apps
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        jnoortheen.nix-ide
        dracula-theme.theme-dracula
      ];
    })
    discord
    ghostty
  ];
}
