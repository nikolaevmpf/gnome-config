# GNOME NixOS configurations

Nixpkgs: nixos-26.05. The VM profile is based on the installed
`nikolaevmpf/nixos_install` system and its reported filesystem UUIDs.
The installer Disko module is intentionally not imported: switching a
running system must never refer to its placeholder disk path.

## VM

On the existing VM, check that `lsblk -f` still reports the UUIDs in
`hosts/vm/default.nix`, then:

```sh
git clone https://github.com/nikolaevmpf/gnome-config.git ~/gnome-config
cd ~/gnome-config
nix flake lock
git add flake.lock
sudo nixos-rebuild build --flake .#vm
sudo nixos-rebuild boot --flake .#vm
sudo reboot
```

`nixos-rebuild boot` creates a boot entry without replacing the
running session. Keep the previous boot entry until GNOME starts and
the storage mounts are verified. After reboot, use
`sudo nixos-rebuild switch --flake .#vm` for subsequent changes.

If the VM has little available RAM or disk space, builds may fail due
to resource limits. Check `free -h` and `df -h /nix/store` first.

## Future physical hosts

The shared modules live in `modules/`. Add
`hosts/desktop-nvidia/default.nix` and `hosts/dell/default.nix`,
then register their outputs in `flake.nix` after collecting each
machine's `lspci -nnk`, `lsblk -f`, `findmnt -R /` and existing
hardware configuration. Each host must specify its own filesystems,
bootloader and GPU settings. Do not copy VM UUIDs to other hosts.

Steam is enabled in the shared gaming module; a Virtio GPU VM may
launch Steam, but 3D game performance depends on VM graphics
acceleration or GPU passthrough.
