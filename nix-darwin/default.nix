{pkgs, ...}: {
  nix.enable = false;

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
      "github-mcp-server"
    ];
    casks = [
      "iterm2"
      "vivaldi"
      "discord"
      "visual-studio-code"
      "google-japanese-ime"
      "box-drive"
      "adobe-acrobat-reader"
      "slack"
      "chatgpt"
      "claude"
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
      "jetbrains-toolbox"
      "docker-desktop"
      "gimp"
      "utm"
      "jellyfin-media-player"
      "steam"
      "Sikarugir-App/sikarugir/sikarugir"
      "minecraft"
      "sidequest"
      "curseforge"
      "modrinth"
      "wifi-explorer"
      "cubicsdr"
      "warp"
      "flrig"
      "fldigi"
      "obs"
      "blackhole-2ch"
      "distroav"
      "libndi"
      "ndi-tools"
    ];
  };
}
