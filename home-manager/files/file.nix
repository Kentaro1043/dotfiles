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
