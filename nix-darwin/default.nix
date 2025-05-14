{pkgs, ...}: {
  nix.enable = false;

  system = {
    stateVersion = "5";

    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
        orientation = "bottom";
      };
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
    casks = [
      "iterm2"
      "vivaldi"
      "visual-studio-code"
    ];
  };
}
