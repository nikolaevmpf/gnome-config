{ pkgs, ... }:
let
  backup = pkgs.writeShellScript "home-manager-backup" ''
    set -eu
    for file in "$@"; do
      ${pkgs.coreutils}/bin/mv -- "$file" "$file.hm-backup-$(${pkgs.coreutils}/bin/date +%s%N)"
    done
  '';
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupCommand = "${backup}";
  home-manager.users.nikolaev = import ../home/nikolaev.nix;
  fonts.packages = [ pkgs.jetbrains-mono ];
}
