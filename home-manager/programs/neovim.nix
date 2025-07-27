{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      astrocore
      astroui
      astrotheme
      astrolsp
    ];
  };
}
