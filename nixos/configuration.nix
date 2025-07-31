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
  };

  users.users.kentaro = {
    isNormalUser = true;
    home = "/home/kentaro";
    createHome = true;
    extraGroups = ["wheel"];
    initialPassword = "password"; # Change this to a secure password
  };

  networking.hostName = "kentaro-win";

  # VSCode Remote workaround
  # https://nix-community.github.io/NixOS-WSL/how-to/vscode.html
  programs.nix-ld.enable = true;
  environment.systemPackages = [
    pkgs.wget
  ];
}
