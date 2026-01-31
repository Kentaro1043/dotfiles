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
    ./programs/codex.nix
    ./programs/eza.nix
    ./programs/git.nix
    ./programs/lazygit.nix
    ./programs/nixvim.nix
    ./programs/ruff.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/texlive.nix
    ./programs/vim.nix
    ./programs/zsh.nix
    ./programs/others.nix
    ./packages.nix
    ./services/ollama.nix
    ./nixos/dconf.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.nixpkgs-2505-packages
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = false;
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "zsh-abbr" # CC BY-NC-SA 4.0 + HIPPOCRATIC LICENSE 3.0
          "stegsolve" # Cronos License
          "burpsuite" # unfree
          "discord" # unfree
        ];
    };
  };

  home = {
    username = "kentaro";
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/kentaro"
      else "/home/kentaro";
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
