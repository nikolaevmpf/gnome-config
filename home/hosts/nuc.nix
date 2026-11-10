{ pkgs, ... }:
{
  imports = [
    ../common/monitoring.nix
    ../common/zed.nix
  ];

  home.packages = with pkgs; [
    celluloid
    lazyssh
    libreoffice
    telegram-desktop
    obsidian
    pinta
    remmina
    transmission_4-gtk
  ];

  dconf.settings."org/gnome/shell".favorite-apps = [
    "firefox.desktop"
    "com.mitchellh.ghostty.desktop"
    "org.gnome.Nautilus.desktop"
    "virt-manager.desktop"
    "obsidian.desktop"
    "ru.max.MAX.desktop"
    "org.telegram.desktop.desktop"
  ];
}
