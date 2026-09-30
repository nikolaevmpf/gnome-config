{ lib, ... }:
{
  imports = [ ./nvidia.nix ];

  networking.hostName = "02i0132";

  boot.initrd.availableKernelModules = [
    "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "sr_mod"
    "virtio_pci" "virtio_scsi" "virtio_blk"
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # System disk identified by filesystem UUIDs; /dev/sdX names may change.
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ac990355-a3db-4b1e-b1a6-4ddee4e9cb3e";
    fsType = "btrfs";
    options = [ "subvol=@root" "compress=zstd" "noatime" ];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/ac990355-a3db-4b1e-b1a6-4ddee4e9cb3e";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/ac990355-a3db-4b1e-b1a6-4ddee4e9cb3e";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" "noatime" ];
  };
  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/ac990355-a3db-4b1e-b1a6-4ddee4e9cb3e";
    fsType = "btrfs";
    options = [ "subvol=@log" "compress=zstd" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0AD0-16F9";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
