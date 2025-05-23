{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=yellow";
    };
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins =
        [
          "keychain"
          "gpg-agent"
          "ssh"
          "sudo"
          "git"
          "git-auto-fetch"
          "gitignore"
          "git-prompt"
          "vscode"
          "docker"
          "docker-compose"
          "kubectl"
          "golang"
          "volta"
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin ["iterm2" "macos"]
        ++ lib.optionals pkgs.stdenv.isLinux ["ubuntu"];
    };

    initExtraFirst = ''
      zstyle :omz:plugins:keychain agents gpg,ssh
      zstyle :omz:plugins:keychain identities id_ed25519
      zstyle :omz:plugins:keychain options --quiet --noask
    '';

    initExtra = ''
      # Load plugins
      # zsh-abbr
      source ${pkgs.zsh-abbr}/share/zsh/zsh-abbr/zsh-abbr.plugin.zsh
      # zsh-you-should-use
      source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
      # zsh-nix-shell
      source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
      # nix-zsh-completions
      source ${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/init.zsh

      # Enable brew when on macOS
      if [ -d /opt/homebrew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
    '';

    shellAliases = {
      update = "home-manager switch --flake .#$USER@$(hostname | sed 's/\.local$//')";
      darwin = "darwin-rebuild switch --flake .#$USER@$(hostname | sed 's/\.local$//')";
      dt = "code ~/source/repos/github.com/Kentaro1043/dotfiles";
      ojt = "oj test";
      ojs = "oj submit";
      ojp = "oj-prepare";
    };

    envExtra =
      ''
        # Disable user@hostname for agnoster theme
        export DEFAULT_USER="kentaro"

        # Change SHELL
        export SHELL="${pkgs.zsh}/bin/zsh"

        ## Typst font
        ## known issue: https://github.com/typst/typst/issues/185
        #export TYPST_FONT_PATHS=${pkgs.noto-fonts-cjk-sans}/share/fonts/opentype/noto-cjk:${pkgs.noto-fonts-cjk-serif}/share/fonts/opentype/noto-cjk

        # C/C++
        export GCC_PKG_PATH=${builtins.readFile "${pkgs.gcc}/nix-support/orig-cc"}
        export LIBC_PKG_PATH=${builtins.readFile "${pkgs.gcc}/nix-support/orig-libc"}
        export C_INCLUDE_PATH="$GCC_PKG_PATH/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc.version}/include:$GCC_PKG_PATH/include:$GCC_PKG_PATH/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc.version}/include-fixed:$LIBC_PKG_PATH/include"
        export CPLUS_INCLUDE_PATH="${pkgs.ac-library.dev}/include:${pkgs.boost.dev}/include:${pkgs.graphviz}/include:$GCC_PKG_PATH/include/c++/${pkgs.gcc.version}:$GCC_PKG_PATH/include/c++/${pkgs.gcc.version}//${pkgs.stdenv.hostPlatform.config}:$GCC_PKG_PATH/include/c++//backward:$GCC_PKG_PATH/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc.version}/include:$GCC_PKG_PATH/include:$GCC_PKG_PATH/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc.version}/include-fixed:$LIBC_PKG_PATH/include"

        # Enable Volta
        export VOLTA_HOME="$HOME/.volta"
        export PATH="$VOLTA_HOME/bin:$PATH"
      ''
      + lib.optionalString pkgs.stdenv.isLinux ''
        # Marp
        export CHROME_PATH="${pkgs.chromium}/bin/chromium"
      ''
      + lib.optionalString pkgs.stdenv.isDarwin ''
        # C/C++ additional for macOS
        export C_INCLUDE_PATH="$C_INCLUDE_PATH:${pkgs.apple-sdk}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include"
        export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:${pkgs.apple-sdk}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include"
      '';
  };
}
