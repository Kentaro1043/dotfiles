{
  boot = {
    kernelModules = ["kvm-intel"];
    blacklistedKernelModules = [
      "dvb_usb_rtl28xxu"
      "rtl2832"
      "rtl2832_sdr"
    ];
    binfmt = {
      emulatedSystems = ["armv7l-linux"];
      preferStaticEmulators = true;
    };
  };

  hardware = {
    graphics.enable = true;
    bluetooth.enable = true;
    openrazer = {
      enable = true;
      users = ["kentaro"];
    };
  };
}
