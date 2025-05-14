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

  fonts.packages = with pkgs; [
    powerline-fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    (nerdfonts.override
      {fonts = ["JetBrainsMono"];})
  ];

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
