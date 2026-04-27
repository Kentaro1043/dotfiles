{
  pkgs,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      "$mod" = "SUPER";

      bind = [
        "$mod, Return, exec, kitty"
        "$mod, D, exec, rofi -show drun"
        "$mod, Q, killactive"
        "$mod, M, exit"
      ];

      exec-once = [
        "waybar"
        "mako"
      ];
    };
  };

  programs = {
    waybar.enable = true;
    rofi.enable = true;
    kitty.enable = true;
  };

  services = {
    mako.enable = true;
  };
}
