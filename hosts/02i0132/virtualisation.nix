{ pkgs, ... }:
{
  # Модуль kvm_intel или kvm_amd загружается по оборудованию процессора.
  boot.kernelModules = [ "kvm" ];
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      # EGL on NVIDIA also opens /dev/nvidia*, not just the DRM render node.
      # Preserve NixOS' namespace setting when overriding verbatimConfig.
      verbatimConfig = ''
        namespaces = []
        cgroup_device_acl = [
          "/dev/null", "/dev/full", "/dev/zero",
          "/dev/random", "/dev/urandom", "/dev/ptmx",
          "/dev/userfaultfd",
          "/dev/nvidia0", "/dev/nvidiactl", "/dev/nvidia-modeset",
          "/dev/nvidia-uvm", "/dev/nvidia-uvm-tools"
        ]
      '';
      swtpm.enable = true;
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  users.users.nikolaev.extraGroups = [ "libvirtd" "kvm" ];
  environment.systemPackages = [ pkgs.qemu_kvm pkgs.virt-viewer ];
}
