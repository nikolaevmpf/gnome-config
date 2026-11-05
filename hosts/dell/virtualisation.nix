{ pkgs, ... }:
{
  boot.kernelModules = [ "kvm-intel" ];
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  users.users.nikolaev.extraGroups = [ "libvirtd" "kvm" ];
  environment.systemPackages = [ pkgs.qemu_kvm pkgs.virt-viewer ];
}
