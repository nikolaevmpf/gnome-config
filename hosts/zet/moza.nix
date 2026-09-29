{ pkgs, ... }:
{
  # MOZA R3 force feedback is supported by the upstream Linux driver.
  boot.kernelModules = [ "hid-universal-pidff" "cdc_acm" "uinput" ];

  # Configure the wheelbase, steering wheel and pedals from GNOME.
  environment.systemPackages = [ pkgs.boxflat ];
  services.udev.packages = [ pkgs.boxflat ];
}
