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
      device = "/dev/disk/by-uuid/2629ed44-c0b4-447f-b5bf-8df2f8bc698b";
      fsType = "btrfs";
      options = [
        "subvol=@root"
        "compress=zstd:3"
        "noatime"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/2629ed44-c0b4-447f-b5bf-8df2f8bc698b";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd:3"
        "noatime"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/2629ed44-c0b4-447f-b5bf-8df2f8bc698b";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "compress=zstd:3"
        "noatime"
      ];
    };
    "/var/log" = {
      device = "/dev/disk/by-uuid/2629ed44-c0b4-447f-b5bf-8df2f8bc698b";
      fsType = "btrfs";
      options = [
        "subvol=@log"
        "compress=zstd:3"
        "noatime"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/56FE-B413";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };
  };
}
