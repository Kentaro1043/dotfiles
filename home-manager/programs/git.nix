{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Kentaro1043";
    userEmail = "71170923+Kentaro1043@users.noreply.github.com";
    lfs.enable = true;
    extraConfig = {
      pull.rebase = false;
      init.defaultBranch = "main";
    };
  };
}
