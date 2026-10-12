{ pkgs, ... }:
{
  home.packages = with pkgs; [ libreoffice telegram-desktop obsidian pinta remmina zed-editor transmission_4-gtk ];
}
