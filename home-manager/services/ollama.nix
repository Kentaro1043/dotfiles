{
  pkgs,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama;
    acceleration = null;
  };
}
