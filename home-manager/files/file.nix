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
  };
}
