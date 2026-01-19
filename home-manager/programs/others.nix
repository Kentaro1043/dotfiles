{pkgs, ...}: {
  programs = {
    bash = {
      enable = false;
    };
    bat = {
      enable = true;
      #settings = {
      #  theme = "Dracula";
      #};
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
    helix = {
      enable = true;
      settings = {
        theme = "dracula";
      };
    };
    htop = {
      enable = true;
    };
    k9s = {
      enable = true;
    };
    kubecolor = {
      enable = true;
      enableAlias = true;
      enableZshIntegration = true;
    };
    sbt = {
      enable = true;
    };
    tex-fmt = {
      enable = true;
    };
    uv = {
      enable = true;
      package = pkgs.uv;
    };
    yt-dlp = {
      enable = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
