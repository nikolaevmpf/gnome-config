# Dell Latitude 3410

Оборудование: Intel UHD Comet Lake-U, Intel AX201, KIOXIA NVMe 256 ГБ, UEFI.

Профиль `.#dell` включает GNOME, Firefox, Ghostty, Dash to Dock, Astra Monitor, LibreOffice, Transmission и QEMU/KVM. Steam, GameMode, Zed, MAX, NVIDIA и MOZA не подключены. Включены Intel microcode, Bluetooth, libinput, power-profiles-daemon и Thermald; автоматический вход отключён.

## Диски

- EFI: `56FE-B413`, монтируется в `/boot`.
- Btrfs: `2629ed44-c0b4-447f-b5bf-8df2f8bc698b`.
- Подтома: `@root`, `@home`, `@nix`, `@log`.

Перед первым применением сверьте UUID и создайте загрузочное поколение:

```sh
lsblk -f
git clone https://github.com/nikolaevmpf/gnome-config.git ~/gnome-config
cd ~/gnome-config
sudo nixos-rebuild boot --flake .#dell
sudo reboot
```

Конфигурация не форматирует диск. До первого применения не используйте `nix-update`, поскольку исходный hostname `nixos` выбирает профиль `vm`.

После перезагрузки:

```sh
hostname
systemctl --failed
findmnt -t btrfs -o TARGET,SOURCE
nmcli device status
ls -l /dev/kvm
virsh -c qemu:///system list --all
```

В UEFI должна быть включена Intel VT-x. Проверьте звук, Bluetooth, тачпад, яркость, батарею и сон. Гибернация на дисковый swap не настроена; используется zram. Последующие обновления: `nix-update`, обновление входов: `nix-update --upgrade`.

Общая структура Home Manager описана в [HOME-MANAGER.md](../../HOME-MANAGER.md).
