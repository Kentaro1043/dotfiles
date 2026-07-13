{
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/79FC-F92C";
    fsType = "exfat";
    options = [
      "nofail"
      "x-systemd.device-timeout=5s"
      "uid=1000"
      "gid=100"
      "umask=0022"
    ];
  };
}
