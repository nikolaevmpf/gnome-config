{ inputs, ... }:
{
  imports = [
    ./hardware.nix
    ./disks.nix
    ./flatpak.nix
  ];

  networking.hostName = "02i0132";

  home-manager.users.nikolaev.home.packages = [
    inputs.opencode-v2.packages.x86_64-linux.default
  ];
}
