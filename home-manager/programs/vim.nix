{pkgs, ...}: {
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      dracula-vim
      nerdtree
    ];
    settings = {
      background = "dark";
    };
    extraConfig = ''
      colorscheme dracula
    '';
  };
}
