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
      oci-cli
      gh

      # fonts
      #noto-fonts-cjk-sans
      #noto-fonts-cjk-serif
      #source-han-sans
      #source-han-sans-vf-otf
      #source-han-sans-vf-ttf

      # shell
      powerline-fonts
      zsh-abbr
      zsh-you-should-use
      zsh-nix-shell
      nix-zsh-completions

      # typst
      typst

      # marp
      marp-cli
      chromium

      # nix
      alejandra

      # tex
      tex-fmt

      # C/C++
      gcc
      llvm
      graphviz
      boost.out
      boost.dev
      ac-library.out
      ac-library.dev

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
    ];

  # Enable font
  fonts.fontconfig.enable = true;
}
