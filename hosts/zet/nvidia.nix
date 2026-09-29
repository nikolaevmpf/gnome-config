{ config, ... }:
{
  # GeForce RTX 4060 Ti (AD106, Ada Lovelace), only display GPU.
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
