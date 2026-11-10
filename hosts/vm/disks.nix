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
      device = "/dev/disk/by-uuid/f5fb4ec1-a38e-4da6-b226-3749da38015e";
      fsType = "btrfs";
      options = [
        "subvol=@root"
        "compress=zstd"
        "noatime"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/f5fb4ec1-a38e-4da6-b226-3749da38015e";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/f5fb4ec1-a38e-4da6-b226-3749da38015e";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "compress=zstd"
        "noatime"
      ];
    };
    "/var/log" = {
      device = "/dev/disk/by-uuid/f5fb4ec1-a38e-4da6-b226-3749da38015e";
      fsType = "btrfs";
      options = [
        "subvol=@log"
        "compress=zstd"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/EF55-A313";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };
  };
}
