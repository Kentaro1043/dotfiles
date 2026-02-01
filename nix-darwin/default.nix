{pkgs, ...}: {
  nix.enable = false;

  determinate-nix.customSettings = {
    extra-experimental-features = [
      "external-builders"
    ];
    external-builders = ''[{"systems":["aarch64-linux","x86_64-linux"],"program":"/usr/local/bin/determinate-nixd","args":["builder"]}]'';
  };

  system = {
    stateVersion = "5";

    primaryUser = "kentaro";

    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
        orientation = "bottom";
      };

      NSGlobalDomain.AppleShowAllExtensions = true;

      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
        FXRemoveOldTrashItems = true;
        NewWindowTarget = "Home";
        ShowPathbar = true;
        ShowStatusBar = true;
      };
    };
  };

  environment = {
    shells = with pkgs; [
      zsh
      bashInteractive
    ];
  };

  programs = {
    zsh = {
      enable = true;
    };
  };

  users.users.kentaro = {
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [
    powerline-fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nerd-fonts.jetbrains-mono
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = [
      "gcenx/wine"
      "Sikarugir-App/sikarugir"
    ];
    brews = [
      "docker-machine"
      "docker-machine-driver-vmware"
      "openvpn"
    ];
    casks = [
      "discord"
      "visual-studio-code"
      "box-drive"
      "adobe-acrobat-reader"
      "slack"
      "obsidian"
      "unity-hub"
      "vlc"
      "tailscale-app"
      "microsoft-office"
      "notion"
      "google-chrome"
      "firefox"
      "postman"
      "wireshark-app"
      "lens"
      "docker-desktop"
      "gimp"
      "utm"
      "steam"
      "Sikarugir-App/sikarugir/sikarugir"
      "minecraft"
      "cubicsdr"
      "warp"
      "flrig"
      "fldigi"
      "obs"
      "blackhole-2ch"
      "blackhole-16ch"
      "blackhole-64ch"
      "vb-cable"
      "virtualbox"
      "balenaetcher"
      "teamviewer"
      "affinity"
      "azookey"
      "zen"
      "rekordbox"
      "ghostty"
      "spotify"
      "cyberduck"
      "netnewswire"
      "dbeaver-community"
      "medis"
      "vscodium"
    ];
  };
}
