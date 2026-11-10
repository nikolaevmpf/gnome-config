{ lib, ... }:
{
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "sr_mod"
    "virtio_pci"
    "virtio_scsi"
    "virtio_blk"
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  services.qemuGuest.enable = true;
}
