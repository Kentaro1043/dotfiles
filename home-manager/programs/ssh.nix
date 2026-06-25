{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      "conf.d/*"
    ];
    extraConfig = ''
      SetEnv TERM=xterm-256color
    '';
    matchBlocks = {
      "*" = {
        identityFile = "~/.ssh/id_ed25519";
        addKeysToAgent = "yes";
        forwardAgent = true;
      };

      "github.com" = {
        user = "git";
      };

      "kentaro-homelab" = {
        host = "kentaro-homelab";
        hostname = "192.168.1.3";
        port = 22;
        user = "kentaro";
      };
      "gce.kentaro1043.com" = {
        port = 50022;
        user = "kentaro";
      };
      "oci.kentaro1043.com" = {
        port = 50022;
        user = "kentaro";
      };
      "private.okenode1.kentaro1043.com" = {
        port = 50022;
        user = "kentaro";
        proxyJump = "oci.kentaro1043.com";
      };
      "private.okenode2.kentaro1043.com" = {
        port = 50022;
        user = "kentaro";
        proxyJump = "oci.kentaro1043.com";
      };
      "private.okenode3.kentaro1043.com" = {
        port = 50022;
        user = "kentaro";
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
        localForwards = [
          {
            bind.port = 61203;
            host.address = "127.0.0.1";
            host.port = 6443;
          }
        ];
      };
      "libra.tokyotech.org" = {
        user = "kentaro1043";
      };
      "w933.tokyotech.org" = {
        user = "kentaro1043";
      };
      "m011.tokyotech.org" = {
        user = "kentaro1043";
      };
      "csc301.tokyotech.org" = {
        user = "kentaro1043";
        localForwards = [
          {
            bind.port = 64301;
            host.address = "127.0.0.1";
            host.port = 6443;
          }
        ];
      };
      "ict201.tokyotech.org" = {
        user = "kentaro1043";
      };
      "ict202.tokyotech.org" = {
        user = "kentaro1043";
      };
      "ict203.tokyotech.org" = {
        user = "kentaro1043";
      };
      "sce311.tokyotech.org" = {
        user = "kentaro1043";
      };
      "sce312.tokyotech.org" = {
        user = "kentaro1043";
      };
      "las211.tokyotech.org" = {
        user = "kentaro1043";
      };
      "arc321.tokyotech.org" = {
        user = "kentaro1043";
      };
      "eee101.tokyotech.org" = {
        user = "kentaro1043";
      };
      "iee221.tokyotech.org" = {
        user = "kentaro1043";
      };

      # JA1YAD
      "sakura.musenken.net" = {
        port = 61178;
        user = "ubuntu";
      };
    };
  };
}
