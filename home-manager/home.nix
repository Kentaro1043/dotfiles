{
  outputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./files
    ./programs
    ./services
    ./nixos

    ./packages.nix
  ];

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
          "zsh-abbr" # CC BY-NC-SA 4.0 + HIPPOCRATIC LICENSE 3.0
          "stegsolve" # Cronos License
          "burpsuite" # unfree
          "discord" # unfree
          "spotify" # unfree
          # "claude-code" # unfree
          # "vscode-extension-anthropic-claude-code" # unfree
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
