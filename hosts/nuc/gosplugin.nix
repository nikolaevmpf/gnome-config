{ pkgs, ... }:
let
  gosplugin = import ../../packages/gosplugin.nix { inherit pkgs; };
in
{
  environment.systemPackages = [ gosplugin ];
  services.pcscd.enable = true;
  home-manager.users.nikolaev.home.file.".mozilla/native-messaging-hosts/firefox.gosuslugi.plugin.json".text =
    builtins.toJSON {
      name = "firefox.gosuslugi.plugin";
      type = "stdio";
      description = "Gosplugin native host";
      allowed_extensions = [ "gosuslugi@plugin" ];
      path = "${gosplugin}/bin/gosplugin";
    };
}
