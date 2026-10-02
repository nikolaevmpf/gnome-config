{ ... }:
{
  imports = [ ./hardware.nix ./apps.nix ./terminal.nix ];
  networking.hostName = "nuc";
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/fc64e8f1-e978-4846-87c6-18308d6a81ce";
    fsType = "btrfs";
    options = [ "subvol=@root" "compress=zstd" "noatime" ];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/fc64e8f1-e978-4846-87c6-18308d6a81ce";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/fc64e8f1-e978-4846-87c6-18308d6a81ce";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" "noatime" ];
  };
  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/fc64e8f1-e978-4846-87c6-18308d6a81ce";
    fsType = "btrfs";
    options = [ "subvol=@log" "compress=zstd" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2AE2-E8A4";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  # Existing ext4 Data volume: mount without formatting or changing ownership.
  fileSystems."/mnt/Data" = {
    device = "/dev/disk/by-uuid/0ae52be7-d75e-4044-8367-a8687251a8cb";
    fsType = "ext4";
    options = [ "noatime" "nofail" "x-systemd.automount" "x-systemd.device-timeout=5s" ];
  };
}
