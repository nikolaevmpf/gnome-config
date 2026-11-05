# Настройки Dash to Dock только для nuc.
{ pkgs, ... }:
{
  dconf.settings = {
    "org/gnome/shell".favorite-apps = [
      "firefox.desktop"
      "com.mitchellh.ghostty.desktop"
      "org.gnome.Nautilus.desktop"
      "virt-manager.desktop"
      "obsidian.desktop"
      "ru.max.MAX.desktop"
      "org.telegram.desktop.desktop"
    ];
    "org/gnome/shell".enabled-extensions = [
      pkgs.gnomeExtensions.dash-to-dock.extensionUuid
    ];
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";
      click-action = "minimize";
      dock-fixed = false;
      intellihide = true;
      autohide = true;
      transparency-mode = "FIXED";
      background-opacity = 0.0;
      show-trash = false;
      show-mounts = false;
    };
  };
  home.packages = [ pkgs.gnomeExtensions.dash-to-dock ];
}
