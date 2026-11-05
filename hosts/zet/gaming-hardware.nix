{ pkgs, ... }:
{
  # MOZA R3 force feedback is supported by the upstream Linux driver.
  boot.kernelModules = [ "hid-universal-pidff" "cdc_acm" "uinput" ];
  services.udev.packages = [ pkgs.boxflat ];
}
