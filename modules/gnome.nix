{ config, lib, pkgs, ... }:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  programs.dconf.enable = true;

  # Applications using the default-terminal specification launch Ghostty.
  xdg.terminal-exec = {
    enable = true;
    settings = {
      GNOME = [ "com.mitchellh.ghostty.desktop" ];
      default = [ "com.mitchellh.ghostty.desktop" ];
    };
  };

  # Add "Open in Ghostty" to the Files context menu.
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };
  services.xserver.xkb.layout = "us,ru";

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Keep the GNOME shell, settings, files and terminal while trimming
  # optional applications. attrByPath tolerates package renames.
  environment.gnome.excludePackages =
    builtins.filter (package: package != null)
      (map (name: lib.attrByPath [ name ] null pkgs) [
        "gnome-console"
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
