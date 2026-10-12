{ pkgs, osConfig, ... }:
let
  ghosttyConfig = ''
    font-family = JetBrains Mono
    font-size = 12
    background = #000000
    foreground = #e6e6e6
    background-opacity = 1
    window-theme = dark
    window-padding-x = 10
    window-padding-y = 8
    cursor-style = block
    cursor-style-blink = false
    mouse-hide-while-typing = true
    scrollback-limit = 33554432
    confirm-close-surface = true
    window-width = 170
    window-height = 45
  '';
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
  # Оба имени используют общие настройки из этого профиля.
  xdg.configFile."ghostty/config".text = ghosttyConfig;
  xdg.configFile."ghostty/config.ghostty".text = ghosttyConfig;
}
