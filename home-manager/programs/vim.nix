{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.vim = {
    enable = true;
    extraConfig = ''
      set runtimepath+=~/.vim_runtime

      source ~/.vim_runtime/vimrcs/basic.vim
      source ~/.vim_runtime/vimrcs/filetypes.vim
      source ~/.vim_runtime/vimrcs/plugins_config.vim
      source ~/.vim_runtime/vimrcs/extended.vim

      set background=dark
      colorscheme solarized
    '';
  };
}
