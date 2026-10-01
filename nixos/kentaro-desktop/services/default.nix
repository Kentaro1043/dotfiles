{...}: {
  imports = [
    ./ollama.nix
    ./open-webui.nix
    ./udev.nix
  ];

  services = {
    envfs.enable = true;
    tailscale.enable = true;
    wivrn = {
      enable = true;
      openFirewall = true;
      highPriority = true;
      steam.importOXRRuntimes = true;
    };
  };
}
