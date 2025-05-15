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
          #"keychain"
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

    initExtra = ''
      ## Enable keychain
      #eval `keychain --eval --agents ssh ~/.ssh/id_ed25519`

      # Load plugins
      # zsh-abbr
      source ${pkgs.zsh-abbr}/share/zsh/zsh-abbr/zsh-abbr.plugin.zsh
      # zsh-you-should-use
      source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
      # zsh-nix-shell
      source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
      # nix-zsh-completions
      source ${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/init.zsh

      # Enable brew
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    shellAliases = {
      update = "home-manager switch --flake .#$USER@$(hostname | sed 's/\.local$//')";
      darwin = "darwin-rebuild switch --flake .#$USER@$(hostname | sed 's/\.local$//')";
    };

    envExtra = ''
      # Disable user@hostname for agnoster theme
      export DEFAULT_USER="kentaro"

      # Change SHELL
      export SHELL="${pkgs.zsh}/bin/zsh"

      # Typst font
      export TYPST_FONT_PATHS=${pkgs.noto-fonts}/share/fonts/noto:${pkgs.noto-fonts-cjk-sans}/share/fonts/opentype/noto-cjk:${pkgs.noto-fonts-cjk-serif}/share/fonts/opentype/noto-cjk

      # Enable Volta
      export VOLTA_HOME="$HOME/.volta"
      export PATH="$VOLTA_HOME/bin:$PATH"
    '';
  };
}
