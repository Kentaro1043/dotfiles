{config, ...}: {
  programs.rclone = {
    enable = true;

    remotes.homelab-music = {
      config = {
        type = "webdav";
        url = "https://music-sync.internal.kentaro1043.com";
        vendor = "rclone";
        user = "rclone";
      };
      secrets.pass = config.sops.secrets.rclone-music-password.path;
    };
  };
}
