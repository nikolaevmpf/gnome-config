# Настройки GNOME только для vm.
{ lib, pkgs, ... }:
{
  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Classic";
      gtk-enable-primary-paste = true;
    };
    "org/gnome/desktop/input-sources".sources = [
      (lib.gvariant.mkTuple [ "xkb" "us" ])
      (lib.gvariant.mkTuple [ "xkb" "ru" ])
    ];
    "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/"
    ];
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty" = {
      name = "Ghostty";
      command = "ghostty";
      binding = "<Primary><Alt>t";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "";
      picture-uri-dark = "";
      picture-options = "none";
      color-shading-type = "solid";
      primary-color = "#000000";
      secondary-color = "#000000";
    };
    "org/gnome/desktop/wm/preferences".button-layout = ":minimize,maximize,close";
  };
  home.packages = [ pkgs.firefox pkgs.bibata-cursors pkgs.papirus-icon-theme ];
  home.sessionVariables.XCURSOR_THEME = "Bibata-Modern-Classic";
}
