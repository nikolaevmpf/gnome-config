{ ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7bcd30d7-6ded-48b4-b17d-1160840adb72";
    fsType = "btrfs";
    options = [ "subvol=@root" "compress=zstd" "noatime" ];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/7bcd30d7-6ded-48b4-b17d-1160840adb72";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/7bcd30d7-6ded-48b4-b17d-1160840adb72";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" "noatime" ];
  };
  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/7bcd30d7-6ded-48b4-b17d-1160840adb72";
    fsType = "btrfs";
    options = [ "subvol=@log" "compress=zstd" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1B70-3CD2";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  fileSystems."/games" = {
    device = "/dev/disk/by-uuid/20b6bd92-e375-402e-a18c-abe43cf65b79";
    fsType = "btrfs";
    options = [
      "subvolid=5" "compress=zstd" "noatime"
      "nofail" "x-systemd.automount" "x-systemd.device-timeout=5s"
    ];
  };
}
