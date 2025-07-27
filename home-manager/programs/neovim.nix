{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    plugins = [
      pkgs.vimPlugins.astrocore
    ];
  };
}
