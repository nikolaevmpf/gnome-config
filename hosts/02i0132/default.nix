{ lib, pkgs, opencode-v2, ... }:
{
  imports = [ ./nvidia.nix ./virtualisation.nix ];

  networking.hostName = "02i0132";

  # OpenCode 2.1.4 pinned to its upstream release commit; only on 02i0132.
  home-manager.users.nikolaev.home.packages = [ opencode-v2.packages.x86_64-linux.default ];

  programs.amnezia-vpn.enable = true;


  # MAX is distributed via the community Flatpak wrapper on Flathub.
  services.flatpak.enable = true;
  systemd.services.install-max = {
    description = "Install MAX Messenger from Flathub";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      if ! flatpak info --system ru.max.MAX >/dev/null 2>&1; then
        flatpak install --system --noninteractive -y flathub ru.max.MAX
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = "60s";
      TimeoutStartSec = "15min";
    };
  };


  boot.initrd.availableKernelModules = [
    "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "sr_mod"
    "virtio_pci" "virtio_scsi" "virtio_blk"
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # System disk identified by filesystem UUIDs; /dev/sdX names may change.
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ac990355-a3db-4b1e-b1a6-4ddee4e9cb3e";
    fsType = "btrfs";
    options = [ "subvol=@root" "compress=zstd" "noatime" ];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/ac990355-a3db-4b1e-b1a6-4ddee4e9cb3e";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/ac990355-a3db-4b1e-b1a6-4ddee4e9cb3e";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" "noatime" ];
  };
  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/ac990355-a3db-4b1e-b1a6-4ddee4e9cb3e";
    fsType = "btrfs";
    options = [ "subvol=@log" "compress=zstd" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0AD0-16F9";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
