{ inputs, ... }:
{
  imports = [
    ./hardware.nix
    ./gosplugin.nix
    ./disks.nix
    ./mounts.nix
  ];

  networking.hostName = "nuc";

  services.displayManager.autoLogin = {
    enable = true;
    user = "nikolaev";
  };

  home-manager.users.nikolaev.home.packages = [
    inputs.opencode-v2.packages.x86_64-linux.default
  ];

  networking.hosts = {
    "192.168.1.59" = [ "zet" ];
    "192.168.1.149" = [ "nuc" ];
  };
}
