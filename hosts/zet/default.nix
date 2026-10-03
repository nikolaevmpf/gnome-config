{ lib, ... }:
{
  imports = [ ./nvidia.nix ./moza.nix ./terminal.nix ];

  networking.hostName = "zet";

  boot.initrd.availableKernelModules = [
    "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "sr_mod"
    "virtio_pci" "virtio_scsi" "virtio_blk"
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Системный диск идентифицируется по UUID файловой системы; имена /dev/sdX могут изменяться.
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7bcd30d7-6ded-48b4-b17d-1160840adb72";
    fsType = "btrfs";
    options = [ "subvol=@root" "compress=zstd" "noatime" ];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/7bcd30d7-6ded-48b4-b17d-1160840adb72";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/7bcd30d7-6ded-48b4-b17d-1160840adb72";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" "noatime" ];
  };
  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/7bcd30d7-6ded-48b4-b17d-1160840adb72";
    fsType = "btrfs";
    options = [ "subvol=@log" "compress=zstd" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1B70-3CD2";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  # Диск с играми идентифицируется по UUID файловой системы; имена /dev/sdX могут изменяться.
  fileSystems."/games" = {
    device = "/dev/disk/by-uuid/20b6bd92-e375-402e-a18c-abe43cf65b79";
    fsType = "btrfs";
    # Mount on access; an unavailable game disk must not hold up boot.
    # Automount also prevents writes to the system disk at /games.
    options = [
      "subvolid=5" "compress=zstd" "noatime"
      "nofail" "x-systemd.automount" "x-systemd.device-timeout=5s"
    ];
  };
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Статические записи для локальной сети.
  networking.hosts = {
    "192.168.1.59" = [ "zet" ];
    "192.168.1.149" = [ "nuc" ];
  };
}
