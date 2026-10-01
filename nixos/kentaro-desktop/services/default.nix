{...}: {
  imports = [
    ./ollama.nix
    ./open-webui.nix
    ./udev.nix
  ];

  services = {
    envfs.enable = true;
    tailscale.enable = true;
  };
}
