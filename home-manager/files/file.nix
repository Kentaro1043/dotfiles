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
      ./oj/prepare.config.toml;
    "${
      if pkgs.stdenv.isDarwin
      then "Library/Application Support"
      else ".config"
    }/online-judge-tools/template/main.cpp".source =
      ./oj/main.cpp;

    # gnuradio
    ".config/gnuradio/config.conf".source = ./gnuradio/config.conf;

    # Ghostty
    # only for macOS
    ".config/ghostty/config".source = ./ghostty/config;

    # Continue VSCode Extention
    ".continue/config.yaml".source = ./continue/config.yaml;
  };
}
