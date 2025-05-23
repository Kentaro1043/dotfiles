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
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
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

      # nix
      alejandra

      # tex
      tex-fmt

      # C/C++
      gcc
      llvm
      clang-tools
      graphviz
      boost.out
      boost.dev
      ac-library.out
      ac-library.dev

      # python
      pkgs-unstable.uv
      yapf

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
      online-judge-template-generator
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      # Docker
      # Disable on Linux because I use Docker Desktop on Windows
      docker
      colima
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      gdb

      # marp
      marp-cli
      chromium
    ];

  # Enable font
  fonts.fontconfig.enable = true;
}
