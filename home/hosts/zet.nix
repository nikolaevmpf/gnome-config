{ pkgs, ... }:
{
  imports = [ ../common/monitoring.nix ];

  home.packages = with pkgs; [
    celluloid
    lazyssh
    transmission_4-gtk
    boxflat
  ];

  dconf.settings."org/gnome/shell".favorite-apps = [
    "firefox.desktop"
    "com.mitchellh.ghostty.desktop"
    "org.gnome.Nautilus.desktop"
    "steam.desktop"
  ];
}
