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
      device = "/dev/disk/by-uuid/fc64e8f1-e978-4846-87c6-18308d6a81ce";
      fsType = "btrfs";
      options = [
        "subvol=@root"
        "compress=zstd"
        "noatime"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/fc64e8f1-e978-4846-87c6-18308d6a81ce";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/fc64e8f1-e978-4846-87c6-18308d6a81ce";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "compress=zstd"
        "noatime"
      ];
    };
    "/var/log" = {
      device = "/dev/disk/by-uuid/fc64e8f1-e978-4846-87c6-18308d6a81ce";
      fsType = "btrfs";
      options = [
        "subvol=@log"
        "compress=zstd"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/2AE2-E8A4";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };
  };
}
