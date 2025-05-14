{pkgs, ...}: {
  nix.enable = false;

  system = {
    stateVersion = "5";

    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
        orientation = "left";
      };
    };
  };
}
