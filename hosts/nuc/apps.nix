{ pkgs, nixpkgs-unstable, ... }:
{
  imports = [ ./virtualisation.nix ];

programs.amnezia-vpn = { 
   enable = true;
   package = (nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.amnezia-vpn).overrideAttrs (oldAttrs: {
     # nixpkgs#474746: remove the trailing literal \\n from AGW public keys.
     preConfigure = (oldAttrs.preConfigure or "") + ''
       export PROD_AGW_PUBLIC_KEY="$(printf '%s' "$PROD_AGW_PUBLIC_KEY" | sed 's/[\\]n$//')"
       export DEV_AGW_PUBLIC_KEY="$(printf '%s' "$DEV_AGW_PUBLIC_KEY" | sed 's/[\\]n$//')"
     '';
   }); 
 };


  # Runtime tools required by the newer AmneziaVPN package.
  systemd.services.AmneziaVPN.path = with pkgs; [
    gawk
    iptables
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
