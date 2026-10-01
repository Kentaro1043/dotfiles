{
  inputs,
  pkgs,
  ...
}: {
  environment.etc."wivrn/config.json".text = builtins.toJSON {
    openvr-compat-path = "${pkgs.xrizer}/lib/xrizer";
  };

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
      package = pkgs.callPackage "${inputs.nixpkgs-wivrn}/pkgs/by-name/wi/wivrn/package.nix" {};
      openFirewall = true;
      highPriority = true;
      steam.importOXRRuntimes = true;
    };
  };
}
