{ pkgs, ... }:
{
  users.users.nikolaev = {
    isNormalUser = true;
    description = "NixOS administrator";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
  };
}
