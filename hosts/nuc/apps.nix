{ pkgs, ... }:
{
  programs.amnezia-vpn.enable = true;

  environment.systemPackages = with pkgs; [
    libreoffice
    telegram-desktop
    obsidian
    pinta
    remmina
    vscode
    transmission_4-gtk
  ];

  # MAX is distributed via the community Flatpak wrapper on Flathub.
  services.flatpak.enable = true;
  systemd.services.install-max = {
    description = "Install MAX Messenger from Flathub";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      if ! flatpak info --system ru.max.MAX >/dev/null 2>&1; then
        flatpak install --system --noninteractive -y flathub ru.max.MAX
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = "60s";
      TimeoutStartSec = "15min";
    };
  };


}
