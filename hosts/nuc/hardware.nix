{ lib, ... }:
{
  # Intel NUC8i7HVK: i7-8809G, Intel HD 630 and Radeon RX Vega M GH.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth.enable = true;
  };
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "ahci"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [
    "i915"
    "amdgpu"
  ];

}
