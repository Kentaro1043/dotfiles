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
    ./programs/bash.nix
    ./programs/zsh.nix
    ./programs/vim.nix
    ./programs/git.nix
    ./programs/ssh.nix
    ./programs/texlive.nix
    ./programs/kubecolor.nix
    ./programs/htop.nix
    ./programs/direnv.nix
    ./programs/uv.nix
    ./programs/ruff.nix
    ./programs/tex-fmt.nix
    ./programs/yt-dlp.nix
    ./programs/k9s.nix
    ./programs/starship.nix
    ./packages.nix
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
