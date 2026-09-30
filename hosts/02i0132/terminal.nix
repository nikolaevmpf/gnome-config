{ pkgs, ... }:
{
  fonts.packages = [ pkgs.jetbrains-mono ];
  environment.etc."ghostty/02i0132.conf".source = ./ghostty.conf;

  # Include the host config without replacing existing personal settings.
  systemd.user.services.ghostty-host-config = {
    description = "Connect Ghostty to the host configuration";
    wantedBy = [ "default.target" ];
    serviceConfig.Type = "oneshot";
    path = [ pkgs.coreutils pkgs.gnugrep ];
    script = ''
      config_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
      mkdir -p "$config_dir"
      config_file="$config_dir/config.ghostty"
      if [ ! -e "$config_file" ] && [ -e "$config_dir/config" ]; then
        config_file="$config_dir/config"
      fi
      touch "$config_file"
      include="config-file = /etc/ghostty/02i0132.conf"
      if ! grep -Fxq "$include" "$config_file"; then
        printf '\n# Конфигурация хоста NixOS\n%s\n' "$include" >> "$config_file"
      fi
    '';
  };
}
