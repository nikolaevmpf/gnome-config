{ ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2629ed44-c0b4-447f-b5bf-8df2f8bc698b";
    fsType = "btrfs";
    options = [ "subvol=@root" "compress=zstd:3" "noatime" ];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/2629ed44-c0b4-447f-b5bf-8df2f8bc698b";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd:3" "noatime" ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/2629ed44-c0b4-447f-b5bf-8df2f8bc698b";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd:3" "noatime" ];
  };
  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/2629ed44-c0b4-447f-b5bf-8df2f8bc698b";
    fsType = "btrfs";
    options = [ "subvol=@log" "compress=zstd:3" "noatime" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/56FE-B413";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };
}
