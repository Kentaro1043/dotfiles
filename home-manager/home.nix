{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [

  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "kentaro";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/kentaro" else "/home/kentaro";
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
