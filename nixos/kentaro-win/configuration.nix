{
  config,
  lib,
  pkgs,
  ...
}: {
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";

  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  nix.settings.experimental-features = "nix-command flakes";

  wsl = {
    enable = true;
    defaultUser = "kentaro";
    docker-desktop.enable = true;
  };

  sops = {
    defaultSopsFile = ../secrets/secrets.enc.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    # https://github.com/Mic92/sops-nix#setting-a-users-password
    secrets.hashedPassword.neededForUsers = true;
  };

  users.users.kentaro = {
    isNormalUser = true;
    home = "/home/kentaro";
    createHome = true;
    extraGroups = [
      "wheel"
      "plugdev"
    ];
    hashedPasswordFile = config.sops.secrets.hashedPassword.path;
    shell = pkgs.zsh;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  networking.hostName = "kentaro-win";

  time.timeZone = "Asia/Tokyo";

  hardware = {
    rtl-sdr.enable = true;
  };

  services = {
    udev.enable = true;
  };

  # Workaround for VSCode Remote
  # https://nix-community.github.io/NixOS-WSL/how-to/vscode.html
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    kmod
    usbutils
  ];

  programs = {
    zsh = {
      enable = true;
    };

    gnupg = {
      agent = {
        enable = true;
      };
    };
  };
}
