{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs;
    [
      # general
      git
      git-filter-repo
      gnumake
      keychain
      typst
      oci-cli
      gh

      # fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # shell
      powerline-fonts
      zsh-abbr
      zsh-you-should-use
      zsh-nix-shell
      nix-zsh-completions

      # nix
      alejandra

      # tex
      tex-fmt

      # C/C++
      gcc
      llvm
      graphviz
      boost
      ac-library

      # python
      pkgs-unstable.uv

      # Rust
      rustup

      # node version management
      volta
      # node linter
      biome

      # Scala
      scala
      scalafmt

      # yaml linter
      yamllint

      # Kubernetes related packages
      kubectl
      kustomize
      sops
      age
      kustomize-sops
      kubeconform
      k3d

      # kyopro
      online-judge-tools
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      # Docker
      # Disable on Linux because I use Docker Desktop on Windows
      docker
      colima
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      gdb
      gccgo
    ];

  # Enable font
  fonts.fontconfig.enable = true;
}
