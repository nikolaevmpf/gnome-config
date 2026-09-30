# Рабочая машина 02i0132

Профиль `.#02i0132`: GNOME/GDM, Firefox, Ghostty, Dash to Dock,
общие настройки интерфейса, сеть, PipeWire и автоматическая очистка Nix.
Steam, GameMode и настройки руля в рабочий профиль не включены.

Оборудование: ASRock H670M Pro RS, RTX 2080 Ti (TU102), 32 ГБ ОЗУ.
Загрузка UEFI через systemd-boot; используется стабильный драйвер NVIDIA
с открытыми модулями ядра, поддерживающими Turing.

UUID прочитаны с фотографии установленной системы:
- EFI: `0AD0-16F9`, монтируется в `/boot`.
- Btrfs: `ac990355-a3db-4b1e-b1a6-4ddee4e9cb3e`.
- Подтома установщика: `@root`, `@home`, `@nix`, `@log`.

## Первое применение

Сначала проверьте UUID командой `lsblk -f` и подтома командой
`findmnt -t btrfs -o TARGET,SOURCE`. При расхождении исправьте
`hosts/02i0132/default.nix` до сборки. Конфигурация не форматирует диск.

Если репозитория ещё нет:

```sh
git clone https://github.com/nikolaevmpf/gnome-config.git ~/gnome-config
cd ~/gnome-config
```

Если он уже скачан:

```sh
cd ~/gnome-config
git pull --ff-only
```

Проверьте наличие обоих устройств и создайте новое загрузочное поколение:

```sh
test -e /dev/disk/by-uuid/0AD0-16F9 &&
test -e /dev/disk/by-uuid/ac990355-a3db-4b1e-b1a6-4ddee4e9cb3e &&
sudo nixos-rebuild boot --flake .#02i0132
```

Перезагрузитесь только после успешного завершения сборки:

```sh
sudo reboot
```

После перезагрузки:

```sh
hostname
nvidia-smi
findmnt -t btrfs -o TARGET,SOURCE
```

При проблемах выберите предыдущее поколение NixOS в меню загрузки.
Для последующих обновлений используйте
`sudo nixos-rebuild switch --flake .#02i0132`.

Сборка и работа на оборудовании должны быть проверены на этой машине.
