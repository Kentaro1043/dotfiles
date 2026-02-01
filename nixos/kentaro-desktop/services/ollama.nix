{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama-cuda;
    environmentVariables = {
      LD_LIBRARY_PATH = "${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH";
    };
  };
}
