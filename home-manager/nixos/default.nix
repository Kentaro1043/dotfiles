{...}: {
  imports = [
    ./packages.nix
    ./services.nix
    ./wayland.nix
    # ./dconf.nix # for GNOME
  ];
}
