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
      package = (pkgs.callPackage "${inputs.nixpkgs-wivrn}/pkgs/by-name/wi/wivrn/package.nix" {}).overrideAttrs (old: {
        monado = old.monado.overrideAttrs (monado: {
          postPatch = monado.postPatch + ''
            patch -p1 < ${./patches/wivrn-layer-flags-quirk.patch}
            patch -p1 < ${./patches/wivrn-fs2020-quirk.patch}
          '';
        });
      });
      openFirewall = true;
      highPriority = true;
      steam.importOXRRuntimes = true;
    };
  };
}
