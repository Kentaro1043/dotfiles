{pkgs, ...}: {
  programs.bash = {
    enable = false;
  };
  programs.bat = {
    enable = true;
    #settings = {
    #  theme = "Dracula";
    #};
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
  programs.helix = {
    enable = true;
    settings = {
      theme = "dracula";
    };
  };
  programs.htop = {
    enable = true;
  };
  programs.k9s = {
    enable = true;
  };
  programs.kubecolor = {
    enable = true;
    enableAlias = true;
    enableZshIntegration = true;
  };
  programs.tex-fmt = {
    enable = true;
  };
  programs.uv = {
    enable = true;
    package = pkgs.unstable.uv;
  };
  programs.yt-dlp = {
    enable = true;
  };
}
