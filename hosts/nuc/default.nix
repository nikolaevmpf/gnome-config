_: {
  imports = [
    ./hardware.nix
    ./disks.nix
    ./mounts.nix
  ];

  networking.hostName = "nuc";

  services.displayManager.autoLogin = {
    enable = true;
    user = "nikolaev";
  };

  networking.hosts = {
    "192.168.1.59" = [ "zet" ];
    "192.168.1.149" = [ "nuc" ];
  };
}
