{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
      "git.trap.jp" = {
        port = 2200;
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
