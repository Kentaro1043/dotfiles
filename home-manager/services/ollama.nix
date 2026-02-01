{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package =
      if pkgs.stdenv.isLinux
      then pkgs.ollama-cuda
      else pkgs.ollama;
  };
}
