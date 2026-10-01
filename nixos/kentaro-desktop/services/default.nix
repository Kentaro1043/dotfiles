{
  inputs,
  pkgs,
  ...
}: {
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
      package = inputs.nixpkgs-wivrn.legacyPackages.${pkgs.stdenv.hostPlatform.system}.wivrn;
      openFirewall = true;
      highPriority = true;
      steam.importOXRRuntimes = true;
    };
  };
}
