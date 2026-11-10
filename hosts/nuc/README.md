# Intel NUC nuc

Оборудование: NUC8i7HVK, Core i7-8809G, Intel HD 630, Radeon RX Vega M GH, Intel Wireless 8265, UEFI.

Профиль `.#nuc` включает офисные приложения, Telegram, Obsidian, Pinta, Remmina, Transmission, Zed с Kimi Code CLI, Astra Monitor, MAX и QEMU/KVM. Steam, GameMode и Amnezia VPN не подключены. Автоматический вход пользователя `nikolaev` включён.

## Диски

- EFI: `2AE2-E8A4`, монтируется в `/boot`.
- Системный Btrfs: `fc64e8f1-e978-4846-87c6-18308d6a81ce`.
- Подтома: `@root`, `@home`, `@nix`, `@log`.
- Дополнительный ext4 Data: `0ae52be7-d75e-4044-8367-a8687251a8cb`, монтируется в `/mnt/Data` по обращению с `nofail`.

Перед первым применением:

```sh
lsblk -f
findmnt -t btrfs -o TARGET,SOURCE
git clone https://github.com/nikolaevmpf/gnome-config.git ~/gnome-config
cd ~/gnome-config
sudo nixos-rebuild boot --flake .#nuc
sudo reboot
```

При расхождении UUID измените `hosts/nuc/disks.nix` или `hosts/nuc/mounts.nix`. Конфигурация не форматирует диски и не меняет права на Data.

После перезагрузки:

```sh
hostname
findmnt /mnt/Data
systemctl --failed
ls -l /dev/kvm
virsh -c qemu:///system list --all
```

До первого применения не используйте автоматический выбор профиля `nix-update`: исходный hostname `nixos` соответствует `vm`. После настройки используйте `nix-update`.

## QEMU/KVM

Роль `modules/roles/virtualization.nix` включает libvirtd, virt-manager, virt-viewer, swtpm, virtiofsd и SPICE USB. Пользователь входит в группы `libvirtd` и `kvm`. В UEFI должна быть включена Intel VT-x.

Образы по умолчанию хранятся в `/var/lib/libvirt/images`. Перенос на `/mnt/Data` выполняется отдельно после проверки монтирования.

## MAX

Установка выполняется службой `install-max` из Flathub. Диагностика и ручное обновление:

```sh
journalctl -u install-max --no-pager -n 50
sudo flatpak update --system ru.max.MAX
```

Общая структура Home Manager описана в [HOME-MANAGER.md](../../HOME-MANAGER.md).
