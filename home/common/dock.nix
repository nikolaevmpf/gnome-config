{ pkgs, ... }:
{
  dconf.settings."org/gnome/shell".enabled-extensions = [
    pkgs.gnomeExtensions.dash-to-dock.extensionUuid
  ];

  dconf.settings."org/gnome/shell/extensions/dash-to-dock" = {
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

  home.packages = [ pkgs.gnomeExtensions.dash-to-dock ];
}
