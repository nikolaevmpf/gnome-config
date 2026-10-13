{ pkgs, ... }:
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
in
{
  imports = [ ./nuc-gnome.nix ./nuc-dock.nix ./nuc-monitoring.nix ];
  home.packages = with pkgs; [ libreoffice telegram-desktop obsidian pinta remmina zed-editor transmission_4-gtk ];
  # Настройки терминала только для этого хоста.
  xdg.configFile."ghostty/config".text = ghosttyConfig;
  xdg.configFile."ghostty/config.ghostty".text = ghosttyConfig;
}
