{...}: {
  services.udev = {
    extraRules = ''
      SUBSYSTEM=="tty", ATTRS{idVendor}=="0c26", ATTRS{idProduct}=="0046", SYMLINK+="dstar", MODE="0666"
    '';
  };
}
