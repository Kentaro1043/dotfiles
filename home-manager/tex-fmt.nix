{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.tex-fmt = {
    enable = true;
  };
}
