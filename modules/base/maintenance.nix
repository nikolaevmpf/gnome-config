{ config, ... }:
{
  # Системный раздел на всех хостах использует Btrfs.
  services = {
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };

    fstrim.enable = true;

    # Виртуальные диски QEMU обычно не предоставляют SMART.
    smartd.enable = !config.services.qemuGuest.enable;
  };
}
