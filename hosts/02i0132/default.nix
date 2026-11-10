{ inputs, ... }:
{
  imports = [
    ./hardware.nix
    ./disks.nix
    ./mounts.nix
  ];

  networking.hostName = "02i0132";
}
