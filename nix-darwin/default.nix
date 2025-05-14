{pkgs, ...}: {
  nix.enable = false;

  system = {
    dock = {
      autohide = true;
      show-recents = false;
      orientation = "left";
    };
  };
}
