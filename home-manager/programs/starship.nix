{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  programs.starship = {
    enable = true;
    settings = {
      sudo.disabled = false;
      kubernetes = {
        disabled = false;
      };
    };
  };
}
