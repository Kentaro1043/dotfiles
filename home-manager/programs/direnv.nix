{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
