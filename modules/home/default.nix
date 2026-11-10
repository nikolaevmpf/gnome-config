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
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupCommand = "${backup}";
    users.nikolaev = import ../../home/nikolaev.nix;
  };
}
