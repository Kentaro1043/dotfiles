{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.yt-dlp = {
    enable = true;
  };
}
