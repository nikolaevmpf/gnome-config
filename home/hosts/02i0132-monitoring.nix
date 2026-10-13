{ pkgs, ... }:
{
  home.packages = with pkgs.gnomeExtensions; [ astra-monitor vitals ];
  dconf.settings."org/gnome/shell".enabled-extensions = [
    pkgs.gnomeExtensions.astra-monitor.extensionUuid
    pkgs.gnomeExtensions.vitals.extensionUuid
  ];
}
