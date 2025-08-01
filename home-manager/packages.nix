{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      # general
      keychain
      time
      xterm
      ffmpeg-full
      ytdl-sub
      dig
      time
      mongosh
      libwebp
      gemini-cli
      runme
      chroma
      thefuck
      unimatrix

      # general development
      gnumake
      oci-cli
      unstable.minio-client
      go-task
      xc
      devbox
      atlas
      direnv
      envsubst
      buf

      # Git
      git
      git-filter-repo
      gh
      act

      # nvim
      # AstroNvim
      tree-sitter
      bottom
      ripgrep

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

      # markdown
      markdownlint-cli
      markdownlint-cli2

      # typst
      typst

      # nix
      alejandra

      # PostgreSQL
      postgresql

      # C/C++
      gcc
      libllvm
      lldb
      cmake
      spdlog
      spdlog.dev
      clang-tools
      graphviz
      fmt.dev
      boost.out
      boost.dev
      ac-library.out
      ac-library.dev

      # python
      yapf
      virtualenv

      # Rust
      rustup

      # node version management
      unstable.fnm
      # node linter
      unstable.biome
      # Bun
      unstable.bun
      pnpm

      # Scala
      scala
      scalafmt

      # yaml linter
      yamllint
      yamlfmt

      # Kubernetes related packages
      kubectl
      kustomize
      sops
      age
      kustomize-sops
      kubeconform
      k3d
      kubernetes-helm
      kube-linter
      kubeconform

      # Docker
      hadolint
      dive
      lazydocker

      # Radio
      # https://nixos.wiki/wiki/GNU_Radio
      (gnuradio.override {
        extraPackages = with gnuradioPackages; [
          osmosdr
        ];
      })
      hackrf
      soapyrtlsdr
      soapyhackrf

      # kyopro
      online-judge-tools
      online-judge-template-generator

      # .NET
      dotnet-sdk

      # Go
      go
      golangci-lint
      goose
      gotools
      sqldef
      evans

      # Ansible
      ansible
      ansible-lint
      ansible-language-server
      ansible-later
      ansible-doctor
      ansible-navigator
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      # Docker
      # Disable on Linux because I use Docker Desktop on Windows
      docker
      # colima
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
