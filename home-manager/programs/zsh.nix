{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  noto-fonts-cjk-sans-static = pkgs.unstable.noto-fonts-cjk-sans.override {
    static = true;
  };
  noto-fonts-cjk-serif-static = pkgs.unstable.noto-fonts-cjk-serif.override {
    static = true;
  };
in {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins =
        [
          "keychain"
          "gpg-agent"
          "ssh"
          #"sudo"
          "git"
          "git-auto-fetch"
          "gitignore"
          "git-prompt"
          "git-lfs"
          "vscode"
          "docker"
          "docker-compose"
          "kubectl"
          "golang"
          "volta"
          "direnv"
          "bun"
          "colorize"
          "command-not-found"
          "dotnet"
          "fnm"
          "gh"
          "kube-ps1"
          "terraform"
          "themes"
          "thefuck"
          "fzf"
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin ["iterm2" "macos"]
        ++ lib.optionals pkgs.stdenv.isLinux ["ubuntu"];
    };

    initContent = let
      zshConfigEarlyInit = lib.mkOrder 500 ''
        zstyle :omz:plugins:keychain agents gpg,ssh
        zstyle :omz:plugins:keychain identities id_ed25519
        zstyle :omz:plugins:keychain options --quiet --noask
      '';
      zshConfig = lib.mkOrder 1000 ''
        # Load plugins
        # zsh-abbr
        source ${pkgs.zsh-abbr}/share/zsh/zsh-abbr/zsh-abbr.plugin.zsh
        # zsh-you-should-use
        source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
        # zsh-nix-shell
        source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
        # nix-zsh-completions
        source ${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/init.zsh

        # Disable zsh time
        disable -r time

        # Enable fnm
        eval "$(fnm env --use-on-cd --shell zsh)"

        # Enable brew when on macOS
        if [ -d /opt/homebrew ]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
      '';
    in
      lib.mkMerge [
        zshConfigEarlyInit
        zshConfig
      ];

    shellAliases = {
      # kyopro
      ojt = "oj test --gnu-time time";
      ojs = "oj test --gnu-time time && oj submit main.cpp --yes";
      ojp = "oj-prepare";

      # reset launchpad
      rst = "sudo find 2>/dev/null /private/var/folders/ -type d -name com.apple.dock.launchpad -exec rm -rf {} +; killall Dock";
    };

    envExtra =
      ''
        # zsh colorize plugin
        export ZSH_COLORIZE_TOOL="chroma"

        # bat
        export BAT_THEME="Dracula"

        # Typst font
        # known issue: https://github.com/typst/typst/issues/185
        export TYPST_FONT_PATHS=${noto-fonts-cjk-sans-static}/share/fonts/opentype/noto-cjk:${noto-fonts-cjk-serif-static}/share/fonts/opentype/noto-cjk

        # C/C++
        export GCC_PKG_PATH=${builtins.readFile "${pkgs.gcc}/nix-support/orig-cc"}
        export LIBC_PKG_PATH=${builtins.readFile "${pkgs.gcc}/nix-support/orig-libc"}
        export C_INCLUDE_PATH="$GCC_PKG_PATH/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc.version}/include:$GCC_PKG_PATH/include:$GCC_PKG_PATH/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc.version}/include-fixed:$LIBC_PKG_PATH/include$C_INCLUDE_PATH"
        export CPLUS_INCLUDE_PATH="${pkgs.ac-library.dev}/include:${pkgs.boost.dev}/include:${pkgs.graphviz}/include:$GCC_PKG_PATH/include/c++/${pkgs.gcc.version}:$GCC_PKG_PATH/include/c++/${pkgs.gcc.version}//${pkgs.stdenv.hostPlatform.config}:$GCC_PKG_PATH/include/c++//backward:$GCC_PKG_PATH/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc.version}/include:$GCC_PKG_PATH/include:$GCC_PKG_PATH/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc.version}/include-fixed:$LIBC_PKG_PATH/include:$CPLUS_INCLUDE_PATH"
        export CMAKE_MODULE_PATH="${pkgs.spdlog.dev}/lib/cmake/spdlog:${pkgs.fmt.dev}/lib/cmake/fmt"
        export LD_LIBRARY_PATH="${pkgs.gnuradio}/lib:$LD_LIBRARY_PATH"

        # Python
        export PYTHONPATH="${pkgs.gnuradio}/lib/python3.11/site-packages:${pkgs.gnuradioPackages.osmosdr}/lib/python3.11/site-packages"

        # Node
        export BUN_INSTALL="$HOME/.bun"
        export PATH="$BUN_INSTALL/bin:$PATH"

        # Go
        export GOPATH="$HOME/source/go"
        export PATH="$GOPATH/bin:$PATH"

        # ksops
        export PATH="${pkgs.kustomize-sops}/lib/viaduct.ai/v1/ksops:$PATH"
      ''
      + lib.optionalString pkgs.stdenv.isLinux ''
        # Marp
        export CHROME_PATH="${pkgs.chromium}/bin/chromium"
      ''
      + lib.optionalString pkgs.stdenv.isDarwin ''
        # C/C++ additional for macOS
        export C_INCLUDE_PATH="${pkgs.apple-sdk_15}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include:$C_INCLUDE_PATH"
        export CPLUS_INCLUDE_PATH="${pkgs.apple-sdk_15}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include:$CPLUS_INCLUDE_PATH"

        # Rancher Desktop
        export PATH="$HOME/.rd/bin:$PATH"
      '';
  };
}
