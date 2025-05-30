{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.htop = {
    enable = true;
  };
}
