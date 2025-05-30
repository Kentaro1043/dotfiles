{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.kubecolor = {
    enable = true;
    enableAlias = true;
    enableZshIntegration = true;
  };
}
