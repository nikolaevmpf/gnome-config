{ lib, pkgs, ... }:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Defaults for new users; existing users can change them in Settings.
  programs.dconf.profiles.user.databases = [{
    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      cursor-theme = "Bibata-Modern-Classic";
    };
  }];

  environment.systemPackages = [ pkgs.bibata-cursors ];
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
