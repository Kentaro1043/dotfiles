{pkgs, ...}: {
  nix.enable = false;

  system = {
    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
        orientation = "left";
      };
    };
  };
}
