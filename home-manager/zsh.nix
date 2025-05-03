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
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtra = ''
      # Enable keychain
      eval `keychain --eval --agents ssh ~/.ssh/id_ed25519`
    '';
  };

  home.sessionVariables = {
    SHELL = "/home/kentaro/.nix-profile/bin/zsh";
  };
}
