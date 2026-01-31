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
      ###########
      # General #
      ###########
      time
      file
      magika
      dig
      netcat-gnu
      nmap
      openssl

      #########
      # Tools #
      #########
      imagemagick
      libwebp
      fftw
      ffmpeg-full
      lame
      ytdl-sub
      ssh-to-age
      qemu_full
      zstd

      #########
      # Shell #
      #########
      xterm
      chroma
      keychain
      shellcheck
      jq
      fzf
      # zsh related
      zsh-abbr
      zsh-you-should-use
      zsh-nix-shell
      nix-zsh-completions

      #############
      # Dev Tools #
      #############
      # Task runners
      gnumake
      xc
      go-task

      # Cloud CLI
      google-cloud-sdk
      awscli2
      oci-cli
      minio-client

      # Version Managers
      devbox
      tenv
      mise

      # Git
      git
      git-filter-repo
      gh
      act
      lazygit
      ghq

      # AI Tools
      gemini-cli
      unstable.opencode

      # Others
      atlas
      direnv
      envsubst
      buf
      rclone
      sops
      age
      lazyssh
      lazysql

      ########
      # nvim #
      ########
      # AstroNvim
      tree-sitter
      bottom
      ripgrep

      #######
      # CTF #
      #######
      sleuthkit
      foremost
      ghidra
      john
      hashcat
      exiftool
      stegsolve
      binwalk
      steghide
      hash-identifier
      zsteg

      ############
      # markdown #
      ############
      markdownlint-cli
      markdownlint-cli2

      #########
      # typst #
      #########
      typst
      tinymist

      #######
      # nix #
      #######
      alejandra

      #######
      # SQL #
      #######
      postgresql
      sqlfluff

      #########
      # C/C++ #
      #########
      clang-tools
      gcc
      pkgsCross.riscv64.buildPackages.gcc
      libllvm
      lldb
      cmake
      pkg-config
      libconfig
      spdlog
      spdlog.dev
      graphviz
      fmt.dev
      boost.out
      boost.dev
      ac-library.out
      ac-library.dev
      libxcrypt

      ##########
      # RISC-V #
      ##########
      rars

      ##########
      # python #
      ##########
      python315
      yapf
      virtualenv

      ########
      # Rust #
      ########
      rustup

      ########
      # Java #
      ########
      jdk

      ########
      # Node #
      ########
      fnm
      biome
      bun
      pnpm

      #########
      # Scala #
      #########
      scala
      scalafmt
      metals

      ########
      # yaml #
      ########
      yamllint
      yamlfmt
      yq

      ##############
      # Kubernetes #
      ##############
      kubectl
      kustomize
      kustomize-sops
      kubeconform
      k3d
      kubernetes-helm
      kube-linter
      helm-docs
      chart-testing
      kind
      kubeshark

      ##########
      # Docker #
      ##########
      hadolint
      dive
      lazydocker

      #######
      # SDR #
      #######
      # GUI App
      # https://nixos.wiki/wiki/GNU_Radio
      (gnuradio.override {
        extraPackages = with gnuradioPackages; [
          osmosdr
          lora_sdr
        ];
      })
      rtl-sdr
      wfview
      deprecated.dump1090
      #sdrangel
      #gqrx
      #sdrpp
      #airspy
      # Driver
      hackrf
      soapysdr
      soapyrtlsdr
      soapyhackrf
      soapyremote

      ##########
      # kyopro #
      ##########
      online-judge-tools
      online-judge-template-generator

      ########
      # .NET #
      ########
      dotnet-sdk

      ######
      # Go #
      ######
      go
      golangci-lint
      goose
      gotools
      sqldef
      evans

      ###########
      # Ansible #
      ###########
      ansible
      ansible-lint
      ansible-doctor
      ansible-navigator
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      darwin.IOKitTools
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      # Macではlldbを使用
      gdb

      # marp
      marp-cli
      chromium

      # SDR(Macではhomebrewで入れる)
      cubicsdr

      # CTF
      burpsuite

      # GUI apps
      vscodium
      discord
    ];

  # Enable font
  fonts.fontconfig.enable = true;
}
