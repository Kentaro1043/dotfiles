{...}: {
  programs = {
    alvr = {
      enable = true;
      openFirewall = true;
    };
    hyprland.enable = false;
    nix-ld.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    wireshark = {
      enable = true;
      dumpcap.enable = true;
      usbmon.enable = true;
    };
  };
}
