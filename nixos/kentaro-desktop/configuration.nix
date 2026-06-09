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
          "steam" # unfreeRedistributable
          "steam-unwrapped" # unfreeRedistributable
          "open-webui" # Open WebUI License
        ];
    };
  };

  imports = [
    ./hardware-configuration.nix
    ./programs
    ./services
  ];

  # OS
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [
      "tun"
    ];
  };
  networking = {
    hostName = "kentaro-desktop";
    networkmanager = {
      enable = true;

      ensureProfiles.profiles = {
        "br0" = {
          connection = {
            id = "br0";
            type = "bridge";
            interface-name = "br0";
          };
          bridge = {
            stp = false;
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            method = "auto";
          };
        };

        "br0-port-eth" = {
          connection = {
            id = "br0-port-eth";
            type = "ethernet";
            interface-name = "enp4s0";
            master = "br0";
            slave-type = "bridge";
          };
        };

        # QEMU VM用tapデバイス
        "br0-port-tap" = {
          connection = {
            id = "br0-port-tap";
            type = "tun";
            interface-name = "tap0";
            master = "br0";
            slave-type = "bridge";
          };
          tun = {
            mode = 2; # 1 for tun, 2 for tap
            owner = 1000; # kentaro
            pi = false;
          };
        };
      };
    };

    firewall = {
      checkReversePath = false;
      trustedInterfaces = [
        "docker0"
        "br0"
        "tap0"
      ];
      allowedUDPPortRanges = [
        # KDE Connect
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };
  services.avahi = {
    enable = true;
    openFirewall = true;
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
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-monochrome-emoji
      nerd-fonts.jetbrains-mono
      ipafont
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
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "dialout"
      "wireshark"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Apps
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    git
    home-manager
    openvpn
    bluez
    bubblewrap
    qemu # Needed by Codex
    wireguard-tools
    kdePackages.bluez-qt
    kdePackages.bluedevil
    kdePackages.alligator
    kdePackages.krdc
    openrazer-daemon
    polychromatic
    wireshark
  ];
  virtualisation = {
    virtualbox.host = {
      enable = true;
    };
    docker = {
      enable = true;
    };
  };

  # QEMU
  security.wrappers.qemu-bridge-helper = {
    setuid = true;
    owner = "root";
    group = "root";
    source = "${pkgs.qemu}/libexec/qemu-bridge-helper";
  };
  environment.etc."qemu/bridge.conf".text = ''
    allow br0
  '';

  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
    experimental-features = "nix-command flakes";
  };

  system.stateVersion = "25.11";
}
