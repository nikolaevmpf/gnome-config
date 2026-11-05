{ config, ... }:
{
  # 02i0132: GeForce RTX 2080 Ti (TU102, Turing).
  # The monitor is connected to the NVIDIA GPU; no PRIME setup is needed.
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    # Preserve VRAM across S3 and use the systemd suspend/resume hooks.
    powerManagement.enable = true;
    powerManagement.kernelSuspendNotifier = false;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Disk-backed storage avoids exhausting a tmpfs when saving the 11 GiB VRAM.
  boot.extraModprobeConfig = ''
    options nvidia NVreg_TemporaryFilePath=/var/tmp
  '';
}
