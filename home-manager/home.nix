{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./files/file.nix
    ./bash.nix
    ./zsh.nix
    ./git.nix
    ./ssh.nix
    ./texlive.nix
    ./packages.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "kentaro";
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/kentaro"
      else "/home/kentaro";

    sessionVariables = {
      SHELL = "${pkgs.bash}/bin/bash";
    };
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
