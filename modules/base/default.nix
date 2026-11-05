{ config, pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./network.nix
    ./audio.nix
    ./cleanup.nix
    ./ssh.nix
    ./user.nix
  ];

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "ru_RU.UTF-8";
  console.keyMap = "us";

  zramSwap.enable = true;
  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    pciutils
    usbutils
    nmap
    mc
    gdu
    btop
    duf
  ];

  system.stateVersion = "26.05";
}
