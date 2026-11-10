_: {
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/ac990355-a3db-4b1e-b1a6-4ddee4e9cb3e";
      fsType = "btrfs";
      options = [
        "subvol=@root"
        "compress=zstd"
        "noatime"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/ac990355-a3db-4b1e-b1a6-4ddee4e9cb3e";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/ac990355-a3db-4b1e-b1a6-4ddee4e9cb3e";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "compress=zstd"
        "noatime"
      ];
    };
    "/var/log" = {
      device = "/dev/disk/by-uuid/ac990355-a3db-4b1e-b1a6-4ddee4e9cb3e";
      fsType = "btrfs";
      options = [
        "subvol=@log"
        "compress=zstd"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/0AD0-16F9";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };
  };
}
