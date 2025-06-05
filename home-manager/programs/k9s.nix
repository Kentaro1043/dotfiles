{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.k9s = {
    enable = true;
  };
}
