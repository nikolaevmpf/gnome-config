{ pkgs, ... }:
{
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "ru_RU.UTF-8";
  console.keyMap = "us";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Weekly cleanup removes unreferenced store paths and system generations
  # older than 30 days; recent generations remain available for rollback.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
  services.journald.extraConfig = "SystemMaxUse=500M";

  zramSwap.enable = true;
  services.fwupd.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  users.users.nikolaev = {
    isNormalUser = true;
    description = "NixOS administrator";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
  };

  environment.systemPackages = with pkgs; [
    git vim wget curl pciutils usbutils nmap mc 
  ];

  # Keep the state version from the original installation.
  system.stateVersion = "26.05";
}
