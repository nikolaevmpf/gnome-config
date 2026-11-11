{ pkgs, ... }:
{
  imports = [
    ../common/monitoring.nix
    ../common/zed.nix
  ];

  home.packages = with pkgs; [
    celluloid
    lazyssh
    libreoffice
    telegram-desktop
    obsidian
    pinta
    remmina
    transmission_4-gtk
  ];

  # Аудиовизуализатор: полосы частот в терминале.
  # Источник — PulseAudio-совместимый интерфейс PipeWire (включён в base/audio.nix).
  # Запуск: cava
  programs.cava = {
    enable = true;
    settings = {
      general = {
        framerate = 60;
        bars = 0; # автоподбор по ширине терминала
        sleep_timer = 0;
      };
      input = {
        method = "pulse";
        source = "auto";
      };
      output = {
        method = "ncurses";
        channels = "stereo";
      };
      smoothing = {
        noise_reduction = 0.6;
        monstercat = 1;
        waves = 0;
      };
      color = {
        gradient = 1;
        gradient_count = 6;
        gradient_color_1 = "'#39c5cf'";
        gradient_color_2 = "'#37bdbd'";
        gradient_color_3 = "'#39819d'";
        gradient_color_4 = "'#39548f'";
        gradient_color_5 = "'#392682'";
        gradient_color_6 = "'#390075'";
      };
    };
  };

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
