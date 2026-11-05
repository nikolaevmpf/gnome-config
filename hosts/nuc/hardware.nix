{ lib, ... }:
{
  # Intel NUC8i7HVK: i7-8809G, Intel HD 630 and Radeon RX Vega M GH.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  boot.initrd.availableKernelModules = [
    "xhci_pci" "nvme" "ahci" "usb_storage" "sd_mod"
  ];
  boot.initrd.kernelModules = [ "i915" "amdgpu" ];
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.bluetooth.enable = true;
}
