{ inputs, ... }:
{
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

  home-manager.users.nikolaev.home.packages = [
    inputs.opencode-v2.packages.x86_64-linux.default
    # Kimi Code CLI — terminal AI agent (official flake, self-contained binary).
    # Login: run `kimi`, then /login (Kimi Code OAuth или Moonshot API key).
    inputs.kimi-code.packages.x86_64-linux.default
  ];

  networking.hosts = {
    "192.168.1.59" = [ "zet" ];
    "192.168.1.149" = [ "nuc" ];
  };
}
