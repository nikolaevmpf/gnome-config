{ pkgs, osConfig, ... }:
let
  host = if osConfig.networking.hostName == "nixos" then "vm" else osConfig.networking.hostName;
in
{
  imports = [ ./gnome.nix ./hosts/${host}.nix ];
  home.username = "nikolaev";
  home.homeDirectory = "/home/nikolaev";
  home.stateVersion = "26.05";
  xdg.enable = true;
  programs.home-manager.enable = true;
  programs.ghostty = {
    enable = true;
    systemd.enable = false;
    installBatSyntax = false;
  };
  # Оба имени поддерживаются Ghostty; одинаковые источники исключают старый include.
  xdg.configFile."ghostty/config".source = ./hosts/${host}-ghostty.conf;
  xdg.configFile."ghostty/config.ghostty".source = ./hosts/${host}-ghostty.conf;
}
