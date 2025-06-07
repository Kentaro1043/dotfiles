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
      git
      git-filter-repo
      gh
      gnumake
      keychain
      oci-cli
      gh
      time
      xterm
      ffmpeg-full
      unstable.minio-client
      ytdl-sub
      grafana

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

      # C/C++
      gcc
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
