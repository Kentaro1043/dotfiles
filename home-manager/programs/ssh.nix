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
    settings = {
      "*" = {
        IdentityFile = "~/.ssh/id_ed25519";
        AddKeysToAgent = "yes";
        ForwardAgent = true;
      };

      "github.com" = {
        User = "git";
      };

      "kentaro-homelab" = {
        HostName = "192.168.1.3";
        Port = 22;
        User = "kentaro";
      };
      "gce.kentaro1043.com" = {
        Port = 50022;
        User = "kentaro";
      };
      "oci.kentaro1043.com" = {
        Port = 50022;
        User = "kentaro";
      };
      "private.okenode1.kentaro1043.com" = {
        Port = 50022;
        User = "kentaro";
        ProxyJump = "oci.kentaro1043.com";
      };
      "private.okenode2.kentaro1043.com" = {
        Port = 50022;
        User = "kentaro";
        ProxyJump = "oci.kentaro1043.com";
      };
      "private.okenode3.kentaro1043.com" = {
        Port = 50022;
        User = "kentaro";
        ProxyJump = "oci.kentaro1043.com";
      };

      # traP
      "git.trap.jp" = {
        Port = 2200;
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
      };
      "c1-203.tokyotech.org" = {
        User = "kentaro1043";
        LocalForward = [
          {
            bind.port = 61203;
            host.address = "127.0.0.1";
            host.port = 6443;
          }
        ];
      };
      "libra.tokyotech.org" = {
        User = "kentaro1043";
      };
      "w933.tokyotech.org" = {
        User = "kentaro1043";
      };
      "m011.tokyotech.org" = {
        User = "kentaro1043";
      };
      "csc301.tokyotech.org" = {
        User = "kentaro1043";
        LocalForward = [
          {
            bind.port = 64301;
            host.address = "127.0.0.1";
            host.port = 6443;
          }
        ];
      };
      "ict201.tokyotech.org" = {
        User = "kentaro1043";
      };
      "ict202.tokyotech.org" = {
        User = "kentaro1043";
      };
      "ict203.tokyotech.org" = {
        User = "kentaro1043";
      };
      "sce311.tokyotech.org" = {
        User = "kentaro1043";
      };
      "sce312.tokyotech.org" = {
        User = "kentaro1043";
      };
      "las211.tokyotech.org" = {
        User = "kentaro1043";
      };
      "arc321.tokyotech.org" = {
        User = "kentaro1043";
      };
      "eee101.tokyotech.org" = {
        User = "kentaro1043";
      };
      "iee221.tokyotech.org" = {
        User = "kentaro1043";
      };

      # JA1YAD
      "sakura.musenken.net" = {
        Port = 61178;
        User = "ubuntu";
      };
    };
  };
}
