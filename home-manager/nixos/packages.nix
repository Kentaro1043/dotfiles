{pkgs, ...}: {
  home.packages = with pkgs; [
    # GUI apps
    discord
    ghostty
  ];
}
