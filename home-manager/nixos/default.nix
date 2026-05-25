{...}: {
  imports = [
    ./packages.nix
    ./services.nix
    ./programs.nix
    # ./wayland.nix
    # ./dconf.nix # for GNOME
  ];
}
