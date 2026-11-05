{ ... }:
{
  imports = [
    ./disks.nix
    ./qemu.nix
  ];

  networking.hostName = "nixos";
}
