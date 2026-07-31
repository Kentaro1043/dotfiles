{...}: {
  xdg.configFile."openrazer/razer.conf".text = ''
    [Startup]
    battery_notifier = False
  '';
}
