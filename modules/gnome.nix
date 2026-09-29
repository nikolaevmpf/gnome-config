{ lib, pkgs, ... }:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  programs.firefox.enable = true;

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
    settings."org/gnome/shell".favorite-apps = [
      "firefox.desktop"
      "com.mitchellh.ghostty.desktop"
      "org.gnome.Nautilus.desktop"
    ];
    settings."org/gnome/shell".enabled-extensions = [
      pkgs.gnomeExtensions.dash-to-dock.extensionUuid
    ];
    settings."org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";
      dock-fixed = false;
      intellihide = true;
      autohide = true;
      transparency-mode = "FIXED";
      background-opacity = 0.0;
      show-trash = false;
      show-mounts = false;
    };
    settings."org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/"
    ];
    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty" = {
      name = "Ghostty";
      command = "ghostty";
      binding = "<Primary><Alt>t";
    };
    settings."org/gnome/desktop/wm/preferences".button-layout = ":minimize,maximize,close";
  }];

  environment.systemPackages = [
    pkgs.bibata-cursors
    pkgs.papirus-icon-theme
    pkgs.gnomeExtensions.dash-to-dock
    pkgs.ghostty
  ];
  environment.sessionVariables.XCURSOR_THEME = "Bibata-Modern-Classic";

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
