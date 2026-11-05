{ ... }:
{
  imports = [
    ./hardware.nix
    ./disks.nix
  ];

  networking.hostName = "dell";
}
