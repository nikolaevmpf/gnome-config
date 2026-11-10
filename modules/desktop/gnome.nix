{ lib, pkgs, ... }:
{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xserver.xkb.layout = "us,ru";
  };
  programs.dconf.enable = true;

  xdg.terminal-exec = {
    enable = true;
    settings = {
      GNOME = [ "com.mitchellh.ghostty.desktop" ];
      default = [ "com.mitchellh.ghostty.desktop" ];
    };
  };

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.gnome.excludePackages = builtins.filter (package: package != null) (
    map (name: lib.attrByPath [ name ] null pkgs) [
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
    ]
  );
}
