{ config, ... }:
{
  # GeForce RTX 4060 Ti (AD106, Ada Lovelace), only display GPU.
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    # Preserve VRAM and use NVIDIA's systemd suspend/resume hooks.
    powerManagement.enable = true;
    powerManagement.kernelSuspendNotifier = false;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Store the VRAM snapshot on disk rather than in a potentially small tmpfs.
  boot.extraModprobeConfig = ''
    options nvidia NVreg_TemporaryFilePath=/var/tmp
  '';
}
