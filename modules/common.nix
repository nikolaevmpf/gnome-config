{ pkgs, ... }:
{
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "ru_RU.UTF-8";
  console.keyMap = "ru";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

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
    git vim wget curl pciutils usbutils
  ];

  # Keep the state version from the original installation.
  system.stateVersion = "26.05";
}
