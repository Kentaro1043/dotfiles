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
    };

    #initExtra = ''
    #  # Enable keychain
    #  eval `keychain --eval --agents ssh ~/.ssh/id_ed25519`
    #'';

    envExtra = ''
      # Disable user@hostname for agnoster theme
      export DEFAULT_USER="kentaro"

      # Load plugins
      # zsh-you-should-use
      source ${ pkgs.zsh-you-should-use }/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh

      # Enable Volta
      export VOLTA_HOME="$HOME/.volta"
      export PATH="$VOLTA_HOME/bin:$PATH"
    '';
  };
}
