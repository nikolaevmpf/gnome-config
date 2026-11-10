# Рабочая машина 02i0132

Оборудование: ASRock H670M Pro RS, RTX 2080 Ti (Turing), 32 ГБ ОЗУ, UEFI.

Профиль `.#02i0132` включает GNOME, Firefox, Ghostty, Dash to Dock, Astra Monitor, LibreOffice, Telegram, Obsidian, Pinta, Remmina, Transmission, Zed с Kimi Code CLI, Steam и GameMode. MAX устанавливается системной службой `install-max` из Flathub. Amnezia VPN и настройки руля не подключены.

## Диски

- EFI: `0AD0-16F9`, монтируется в `/boot`.
- Btrfs: `ac990355-a3db-4b1e-b1a6-4ddee4e9cb3e`.
- Подтома: `@root`, `@home`, `@nix`, `@log`.

Перед первым применением сверьте UUID:

```sh
lsblk -f
findmnt -t btrfs -o TARGET,SOURCE
```

При расхождении исправьте `hosts/02i0132/disks.nix`. Затем:

```sh
git clone https://github.com/nikolaevmpf/gnome-config.git ~/gnome-config
cd ~/gnome-config
sudo nixos-rebuild boot --flake .#02i0132
sudo reboot
```

Конфигурация не форматирует диск. После загрузки проверьте `hostname`, `nvidia-smi`, `systemctl --failed` и точки монтирования. Для последующих обновлений используйте `nix-update`.

## MAX

Первая установка требует интернета; при ошибке служба повторяет попытку через минуту.

```sh
journalctl -u install-max --no-pager -n 50
flatpak run ru.max.MAX
sudo flatpak update --system ru.max.MAX
```

Если значок не появился после первой установки Flatpak, перезайдите в GNOME.

## Сон и NVIDIA

Включены открытые модули NVIDIA, modesetting и сохранение видеопамяти в `/var/tmp`. Оставляйте около 12 ГиБ свободного места. Гибернация на дисковый swap не настроена.

После изменения параметров NVIDIA выполните `nix-update` и перезагрузку. Проверка:

```sh
grep -E 'PreserveVideoMemoryAllocations|UseKernelSuspendNotifiers|TemporaryFilePath' /proc/driver/nvidia/params
systemctl status nvidia-suspend.service nvidia-resume.service --no-pager
df -h /var/tmp
```

Сохраните работу перед проверкой `systemctl suspend`. При ошибке:

```sh
sudo journalctl -b -1 -k --no-pager | grep -Ei 'NVRM|Xid|suspend|resume|PM:'
sudo journalctl -b -1 -u nvidia-suspend.service -u nvidia-resume.service --no-pager
```

Работу сна и драйвера необходимо проверять на этом оборудовании. Общая структура Home Manager описана в [HOME-MANAGER.md](../../HOME-MANAGER.md).
