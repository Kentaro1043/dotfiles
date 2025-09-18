{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.bat = {
    enable = true;
    #settings = {
    #  theme = "Dracula";
    #};
  };
}
