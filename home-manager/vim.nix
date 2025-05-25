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
    plugins = with pkgs.vimPlugins; [
      ack-vim
      bufexplorer
      ctrlp-vim
      goyo-vi
      lightline-vim
      nerdtree
      ale
      vim-commentary
      vim-expand-region
      vim-fugitive
      vim-indent-object
      vim-multiple-cursors
      vim-indent-guides
      editorconfig-vim
      copilot-vim
    ];
  };
}
