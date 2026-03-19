{...}: {
  imports = [
    ./ollama.nix
    ./open-webui.nix
  ];

  services = {
    envfs.enable = true;
    tailscale.enable = true;
  };
}
