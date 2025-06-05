{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.bash = {
    enable = true;

    initExtra = ''
      # Execute zsh
      exec zsh
    '';
  };
}
