{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.ruff = {
    enable = true;
  };
}
