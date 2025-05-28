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
      "csc301.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
      };
      "c1-203.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
      };
      "libra.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
      };
      "ict201.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
      };
      "ict202.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
      };
      "ict203.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
