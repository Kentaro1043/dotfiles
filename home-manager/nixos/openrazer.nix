{
  lib,
  pkgs,
  ...
}: {
  xdg.configFile."openrazer/razer.conf" = {
    force = true;
    text = ''
      [Startup]
      battery_notifier = False
    '';
  };

  home.activation.restartOpenRazerDaemon = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${lib.getExe' pkgs.systemd "systemctl"} --user try-restart openrazer-daemon.service
  '';
}
