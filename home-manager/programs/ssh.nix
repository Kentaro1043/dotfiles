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
    includes = [
      "conf.d/*"
    ];
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };

      "gce.kentaro1043.com" = {
        port = 50022;
        user = "kentaro";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "oci.kentaro1043.com" = {
        port = 50022;
        user = "kentaro";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "private.okenode1.kentaro1043.com" = {
        port = 50022;
        user = "kentaro";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
        proxyJump = "oci.kentaro1043.com";
      };
      "private.okenode2.kentaro1043.com" = {
        port = 50022;
        user = "kentaro";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
        proxyJump = "oci.kentaro1043.com";
      };
      "private.okenode3.kentaro1043.com" = {
        port = 50022;
        user = "kentaro";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
        proxyJump = "oci.kentaro1043.com";
      };

      # traP
      "git.trap.jp" = {
        port = 2200;
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
      "c1-203.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "libra.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "taki-ws1.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "taki-ws2.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "taki-ws3.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "taki-ws4.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "e505.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "s512.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
      };
      "w933.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "s323.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "m011.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "s423.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "csc301.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "ict201.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "ict202.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "ict203.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "sce311.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "las211.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "arc321.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "eee101.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
      "iee221.tokyotech.org" = {
        user = "kentaro1043";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };

      # JA1YAD
      "sakura.musenken.net" = {
        port = 61178;
        user = "ja1yad";
        identityFile = "~/.ssh/id_ed25519";
        forwardAgent = true;
      };
    };
  };
}
