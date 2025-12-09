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
    lfs.enable = true;
    settings = {
      user = {
        email = "71170923+Kentaro1043@users.noreply.github.com";
        name = "Kentaro1043";
      };
      pull.rebase = false;
      init.defaultBranch = "main";
    };
  };
}
