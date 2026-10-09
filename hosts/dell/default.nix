{ lib, pkgs, ... }:
{
  imports = [ ./terminal.nix ./virtualisation.nix ];
  networking.hostName = "dell";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "i915" ];
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;
  services.libinput.enable = true;
  services.power-profiles-daemon.enable = true;
  environment.systemPackages = [ pkgs.libreoffice pkgs.transmission_4-gtk ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2629ed44-c0b4-447f-b5bf-8df2f8bc698b";
    fsType = "btrfs";
    options = [ "subvol=@root" "compress=zstd:3" "noatime" ];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/2629ed44-c0b4-447f-b5bf-8df2f8bc698b";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd:3" "noatime" ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/2629ed44-c0b4-447f-b5bf-8df2f8bc698b";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd:3" "noatime" ];
  };
  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/2629ed44-c0b4-447f-b5bf-8df2f8bc698b";
    fsType = "btrfs";
    options = [ "subvol=@log" "compress=zstd:3" "noatime" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/56FE-B413";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };
}
