{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./bash.nix
    ./zsh.nix
  ];

  nixpkgs = {
    # Overlays
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

    sessionVariables = {
      SHELL = "/bin/bash";
    };
  };


  home.packages = with pkgs; [ 
    hello

    # general
    git
    keychain
    
    # shell
    powerline-fonts

    # node version management
    volta
    # node linter
    biome

    # yaml linter
    yamllint

    # Kubernetes related packages
    kubectl
    kustomize
    sops
    age
    kustomize-sops

    # Python
    uv
  ];


  home.file = {
    ".gitconfig" = {
      text = ''
        [user]
          name = Kentaro1043
          email = 71170923+Kentaro1043@users.noreply.github.com
      '';
    };
  };


  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
