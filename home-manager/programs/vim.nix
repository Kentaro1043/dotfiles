{pkgs, ...}: {
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      dracula-vim
    ];
    settings = {
      background = "dark";
    };
    extraConfig = ''
      colorscheme dracula
    '';
  };
}
