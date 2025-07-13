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
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
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
      "tailscale"
      "microsoft-office"
      "notion"
      "google-chrome"
      "firefox"
      "postman"
      "wireshark"
      "lens"
      "jetbrains-toolbox"
    ];
  };
}
