{ pkgs, ... }:
let
  # Use the GNOME 50-compatible source from nixos-unstable with the stable build recipe.
  forge = pkgs.gnomeExtensions.forge.overrideAttrs (_: {
    version = "50.1-development";
    src = pkgs.fetchFromGitHub {
      owner = "forge-ext";
      repo = "forge";
      rev = "0319a7125db1088556b159a69bbec77e111afca7";
      hash = "sha256-IyjHjL1RqxZZZgMnRlmavnae3OqZvRT6aSwKouQRopc=";
    };
  });
in
{
  imports = [ ../common/monitoring.nix ];

  home.packages = with pkgs; [
    forge
    celluloid
    lazyssh
    libreoffice
    telegram-desktop
    obsidian
    pinta
    remmina
    zed-editor
    transmission_4-gtk
  ];

  dconf.settings."org/gnome/shell".enabled-extensions = [ forge.extensionUuid ];

  dconf.settings."org/gnome/shell".favorite-apps = [
    "firefox.desktop"
    "com.mitchellh.ghostty.desktop"
    "org.gnome.Nautilus.desktop"
    "steam.desktop"
    "obsidian.desktop"
    "ru.max.MAX.desktop"
    "org.telegram.desktop.desktop"
  ];
}
