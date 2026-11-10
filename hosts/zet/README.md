# Домашний игровой компьютер zet

Оборудование: ZET Gaming WARD H264, GeForce RTX 4060 Ti (AD106), UEFI.

Профиль `.#zet` включает GNOME, Firefox, Ghostty, Astra Monitor, Steam, GameMode и Boxflat для MOZA R3. Автоматический вход пользователя `nikolaev` включён. Zed, MAX и QEMU/KVM не подключены.

## Диски

- EFI: `1B70-3CD2`, монтируется в `/boot`.
- Системный Btrfs: `7bcd30d7-6ded-48b4-b17d-1160840adb72`, подтома `@root`, `@home`, `@nix`, `@log`.
- Отдельный Btrfs Data: `20b6bd92-e375-402e-a18c-abe43cf65b79`, монтируется в `/games` с `nofail` и автомонтированием.

Перед первым применением:

```sh
lsblk -f
findmnt -t btrfs -o TARGET,SOURCE
git clone https://github.com/nikolaevmpf/gnome-config.git ~/gnome-config
cd ~/gnome-config
sudo nixos-rebuild boot --flake .#zet
sudo reboot
```

При расхождении UUID исправьте `hosts/zet/disks.nix`. Конфигурация не форматирует диски. После загрузки проверьте `nvidia-smi`, `systemctl --failed` и `findmnt / /home /nix /var/log /boot /games`. Для последующих обновлений используйте `nix-update`.

## Библиотека Steam

Сначала убедитесь, что `/games` действительно смонтирован на отдельный диск:

```sh
findmnt /games
sudo install -d -o nikolaev -g users -m 0755 /games/SteamLibrary
```

Если `findmnt` не показывает нужный Btrfs-диск, каталог не создавайте. В Steam выберите **Настройки → Хранилище**, добавьте `/games/SteamLibrary` и назначьте библиотекой по умолчанию.

## Руль MOZA R3

`hosts/zet/gaming-hardware.nix` загружает `hid-universal-pidff`, `cdc_acm` и `uinput`, а также подключает udev-правила Boxflat. После обновления переподключите базу; если драйвер не подхватился, перезагрузитесь.

Диагностика:

```sh
lsusb -d 346e:
lsmod | grep -E 'hid_universal_pidff|cdc_acm'
sudo journalctl -k -b --no-pager | grep -Ei 'moza|pidff|346e|ttyACM'
```

Работа силовой обратной связи также зависит от игры и версии Proton.

## Сон и NVIDIA

Включены открытые модули NVIDIA, modesetting и сохранение видеопамяти в `/var/tmp`. Оставляйте свободное место не меньше объёма видеопамяти плюс небольшой запас. Гибернация на дисковый swap не настроена.

```sh
grep -E 'PreserveVideoMemoryAllocations|UseKernelSuspendNotifiers|TemporaryFilePath' /proc/driver/nvidia/params
df -h /var/tmp
nvidia-smi --query-gpu=memory.total --format=csv
```

Сохраните работу перед проверкой `systemctl suspend`. При ошибке:

```sh
sudo journalctl -b -1 -k --no-pager | grep -Ei 'NVRM|Xid|suspend|resume|PM:'
sudo journalctl -b -1 -u nvidia-suspend.service -u nvidia-resume.service --no-pager
```

Работу сна и драйвера необходимо проверять на оборудовании. Общая структура Home Manager описана в [HOME-MANAGER.md](../../HOME-MANAGER.md).
