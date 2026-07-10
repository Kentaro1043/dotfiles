{
  inputs,
  pkgs,
  ...
}: {
  nix.enable = false;

  determinateNix.customSettings = {
    # extra-experimental-features = [ "external-builders" ];
    # external-builders = ''[{"systems":["aarch64-linux","x86_64-linux"],"program":"/usr/local/bin/determinate-nixd","args":["builder"]}]'';
    trusted-users = ["root" "kentaro"];
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
    systemPackages = [
      # inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    biz-ud-gothic
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = false;
    };
    taps = [
      "gcenx/wine"
      "Sikarugir-App/sikarugir"
    ];
    brews = [
      "openvpn"
    ];
    casks = [
      "discord"
      "box-drive"
      "libreoffice"
      "slack"
      "unity-hub"
      "vlc"
      "tailscale-app"
      "microsoft-office"
      "notion"
      "firefox"
      "postman"
      "wireshark-app"
      "lens"
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
      "cyberduck"
      "dbeaver-community"
      "medis"
      "pycharm"
      "krita"
      "ollama-app"
      "tablecruncher"
      "rustdesk"
      "zotero"
      "freelens"
      "ungoogled-chromium"
      "rancher"
      "warp"
      "zed"
      "raspberry-pi-imager"
      "audacity"
      "claude"
      "codex-app"
      "chatgpt-atlas"
    ];
  };
}
