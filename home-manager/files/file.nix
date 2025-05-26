{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.file = {
    ".latexmkrc".source = ./.latexmkrc;

    ".clang-format".source = ./.clang-format;

    # .vimrc
    ".vim_runtime/autoload".source = "${pkgs.amix-vimrc}/autoload";
    ".vim_runtime/sources_forked".source = "${pkgs.amix-vimrc}/sources_forked";
    ".vim_runtime/sources_non_forked".source = "${pkgs.amix-vimrc}/sources_non_forked";
    ".vim_runtime/vimrcs".source = "${pkgs.amix-vimrc}/vimrcs";

    # online-judge-tools
    "${
      if pkgs.stdenv.isDarwin
      then "Library/Application Support"
      else ".config"
    }/online-judge-tools/prepare.config.toml".source =
      ./prepare.config.toml;
    "${
      if pkgs.stdenv.isDarwin
      then "Library/Application Support"
      else ".config"
    }/online-judge-tools/template/main.cpp".source =
      ./main.cpp;
  };
}
