{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.bash = {
    enable = true;

    initExtra = ''
      # Enable keychain
      eval `keychain --eval --agents ssh ~/.ssh/id_ed25519`

      # Execute zsh
      exec zsh
    '';
  };
}
