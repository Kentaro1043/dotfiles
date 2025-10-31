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
      netcat-gnu
      nmap
      ssh-to-age
      jq
      fzf
      openssl
      imagemagick
      exiftool

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
      tenv
      google-cloud-sdk
      awscli2
      sshpass
      github-copilot-cli
      icecast
      pkg-config
      libconfig
      libshout
      fftw
      lame

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
      shellcheck

      # CTF
      stegsolve
      binwalk
      steghide
      hash-identifier

      # markdown
      markdownlint-cli
      markdownlint-cli2

      # typst
      typst
      tinymist

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
      libxcrypt

      # python
      yapf
      virtualenv

      # Rust
      rustup

      # Java
      jdk

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
      metals

      # yaml linter
      yamllint
      yamlfmt
      yq

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
      helm-docs
      chart-testing
      kind

      # Docker
      hadolint
      dive
      lazydocker

      # Radio
      # https://nixos.wiki/wiki/GNU_Radio
      (gnuradio.override {
        extraPackages = with gnuradioPackages; [
          osmosdr
          lora_sdr
        ];
      })
      gqrx
      hackrf
      soapyrtlsdr
      soapyhackrf
      dump1090
      sdrpp
      airspy
      rtl-sdr
      # sdrangel
      wfview

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

      # R
      R
      rstudio
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      darwin.IOKitTools
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      gdb

      # marp
      marp-cli
      chromium

      # SDR(Macではhomebrewで入れる)
      cubicsdr

      # CTF
      burpsuite
    ];

  # Enable font
  fonts.fontconfig.enable = true;
}
