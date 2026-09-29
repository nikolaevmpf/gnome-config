{ config, ... }:
{
  # 02i0132: GeForce RTX 2080 Ti (TU102, Turing).
  # The monitor is connected to the NVIDIA GPU; no PRIME setup is needed.
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
