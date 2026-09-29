{ lib, pkgs, ... }:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb.layout = "us,ru";

  # Defaults for new users; existing users can change them in Settings.
  programs.dconf.profiles.user.databases = [{
    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Classic";
      gtk-enable-primary-paste = true;
    };
    settings."org/gnome/desktop/input-sources".sources = [
      (lib.gvariant.mkTuple [ "xkb" "us" ])
      (lib.gvariant.mkTuple [ "xkb" "ru" ])
    ];
    settings."org/gnome/desktop/wm/preferences".button-layout = ":minimize,maximize,close";
  }];

  environment.systemPackages = [ pkgs.bibata-cursors pkgs.papirus-icon-theme ];
  environment.sessionVariables.XCURSOR_THEME = "Bibata-Modern-Classic";

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Keep the GNOME shell, settings, files and terminal while trimming
  # optional applications. attrByPath tolerates package renames.
  environment.gnome.excludePackages =
    builtins.filter (package: package != null)
      (map (name: lib.attrByPath [ name ] null pkgs) [
        "gnome-weather"
        "gnome-calendar"
        "gnome-maps"
        "gnome-contacts"
        "gnome-clocks"
        "gnome-tour"
        "gnome-characters"
        "gnome-connections"
        "gnome-music"
        "gnome-photos"
        "gnome-logs"
        "gnome-remote-desktop"
        "yelp"
        "epiphany"
        "simple-scan"
        "showtime"
        "totem"
      ]);
}
