{pkgs, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs.unstable.opencode;
    settings = {
      theme = "dracula";
    };
    themes = {
      dracula = ./opencode-dracula.json;
    };
  };
}
