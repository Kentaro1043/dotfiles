{
  pkgs,
  lib,
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
      coreutils-full
      wget

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
      e2fsprogs
      peco
      squashfs-tools-ng
      libarchive
      socat

      #########
      # Shell #
      #########
      xterm
      chroma
      keychain
      jq
      fzf
      # zsh related
      zsh-abbr
      zsh-you-should-use
      zsh-nix-shell
      nix-zsh-completions

      # Cloud CLI
      google-cloud-sdk
      awscli2
      oci-cli
      minio-client

      # Version Managers
      devbox
      tenv
      unstable.mise
      unstable.usage # Required for mise

      # Git
      git
      git-filter-repo
      gh
      act
      lazygit
      ghq

      # Others
      direnv
      envsubst
      rclone
      sops
      age
      lazyssh
      lazysql
      devpod

      #############
      # AI Agents #
      #############
      llm-agents.qwen-code
      llm-agents.antigravity-cli

      ########
      # nvim #
      ########
      # AstroNvim
      neovim
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

      #######
      # nix #
      #######
      alejandra
      nixd
      cachix

      ########
      # yaml #
      ########
      yq

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
        extraPythonPackages = with gnuradio.python.pkgs; [
          pyqt5
        ];
      })
      rtl-sdr
      wfview
      dump1090-fa
      #sdrangel
      #gqrx
      unstable.sdrpp
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
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      darwin.IOKitTools
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      # SDR(Macではhomebrewで入れる)
      cubicsdr

      # CTF
      burpsuite
    ];

  # Enable font
  fonts.fontconfig.enable = true;
}
