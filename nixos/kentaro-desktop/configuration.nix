{
  outputs,
  pkgs,
  lib,
  ...
}: {
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = false;
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "nvidia-x11" # unfreeRedistributable
          "nvidia-settings" # unfreeRedistributable
          "cuda_cudart" # CUDA EULA
          "cuda_nvcc" # CUDA EULA
          "cuda_cccl" # CUDA EULA
          "libcublas" # CUDA EULA
          "nvidia-x11" # unfreeRedistributable
          "steam" # unfreeRedistributable
          "steam-unwrapped" # unfreeRedistributable
        ];
    };
  };

  imports = [
    ./hardware-configuration.nix
    ./programs
    ./services/ollama.nix
    ./services/tailscale.nix
  ];

  # OS
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  networking = {
    hostName = "kentaro-desktop";
    networkmanager.enable = true;
  };
  time.timeZone = "Asia/Tokyo";
  i18n = {
    defaultLocale = "ja_JP.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "ja_JP.UTF-8";
      LC_IDENTIFICATION = "ja_JP.UTF-8";
      LC_MEASUREMENT = "ja_JP.UTF-8";
      LC_MONETARY = "ja_JP.UTF-8";
      LC_NAME = "ja_JP.UTF-8";
      LC_NUMERIC = "ja_JP.UTF-8";
      LC_PAPER = "ja_JP.UTF-8";
      LC_TELEPHONE = "ja_JP.UTF-8";
      LC_TIME = "ja_JP.UTF-8";
    };

    inputMethod = {
      enable = true;
      # type = "ibus"; # for GNOME
      type = "fcitx5"; # for KDE
      # ibus.engines = with pkgs.ibus-engines; [
      #   anthy
      #   mozc-ut
      # ];
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
      ];
    };
  };

  # X11
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    videoDrivers = ["nvidia"];
  };

  # Enable the GNOME Desktop Environment.
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;

    # To use Wayland (Experimental for SDDM)
    wayland = {
      enable = true;
      compositor = "kwin";
    };
  };

  # Keymap
  services.xserver.xkb = {
    layout = "jp";
    variant = "";
  };

  # CUPS
  services.printing.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Fonts
  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-monochrome-emoji
      nerd-fonts.jetbrains-mono
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif CJK JP"
          "Noto Emoji"
        ];
        sansSerif = [
          "Noto Sans CJK JP"
          "Noto Emoji"
        ];
        monospace = [
          "Noto Sans Mono"
          "Noto Emoji"
        ];
        emoji = ["Noto Emoji"];
      };
    };
  };

  # User
  users.users.kentaro = {
    isNormalUser = true;
    description = "Kentaro";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Apps
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    git
    home-manager
    openvpn
    bluez
    kdePackages.bluez-qt
    kdePackages.bluedevil
  ];
  virtualisation.docker = {
    enable = true;
  };

  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = "25.11";
}
