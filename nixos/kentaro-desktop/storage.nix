{
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-label/Linux";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.device-timeout=5s"
    ];
  };

  fileSystems."/mnt/shared" = {
    device = "/dev/disk/by-label/Shared";
    fsType = "ntfs3";
    options = [
      "nofail"
      "x-systemd.device-timeout=5s"
      "uid=1000"
      "gid=100"
      "umask=0022"
      "windows_names"
    ];
  };
}
