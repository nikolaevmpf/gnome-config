{ pkgs, ... }:
{
  home.packages = [ pkgs.gnomeExtensions.astra-monitor ];
  dconf.settings."org/gnome/shell".enabled-extensions = [
    pkgs.gnomeExtensions.astra-monitor.extensionUuid
  ];
}
