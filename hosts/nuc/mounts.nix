{ ... }:
{
  fileSystems."/mnt/Data" = {
    device = "/dev/disk/by-uuid/0ae52be7-d75e-4044-8367-a8687251a8cb";
    fsType = "ext4";
    options = [ "noatime" "nofail" "x-systemd.automount" "x-systemd.device-timeout=5s" ];
  };
}
