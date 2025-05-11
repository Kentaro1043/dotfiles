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
      plugins = [
        "git"
        "docker"
        "docker-compose"
        "kubectl"
      ];
    };

    initExtra = ''
      ## Enable keychain
      #eval `keychain --eval --agents ssh ~/.ssh/id_ed25519`

      # Load plugins
      # zsh-you-should-use
      source ${ pkgs.zsh-you-should-use }/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
    '';

    envExtra = ''
      # Disable user@hostname for agnoster theme
      DEFAULT_USER="kentaro"

      # Typst font
      export TYPST_FONT_PATHS=${ pkgs.noto-fonts }/share/fonts/noto

      # Enable Volta
      VOLTA_HOME="$HOME/.volta"
      PATH="$VOLTA_HOME/bin:$PATH"
    '';
  };
}
