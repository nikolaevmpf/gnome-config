# Рабочая машина 02i0132

Профиль `.#02i0132`: GNOME/GDM, Firefox, Ghostty, Dash to Dock,
общие настройки интерфейса, сеть, PipeWire и автоматическая очистка Nix.
Для игр включены Steam и GameMode; Steam закреплён в Dash to Dock по умолчанию.
Для работы установлены LibreOffice, Telegram Desktop, Obsidian, Pinta и Remmina.
Для торрентов установлен Transmission 4 с интерфейсом GTK.
MAX устанавливается автоматически через Flatpak из Flathub при наличии интернета.
Это упаковка сообщества, использующая приложение из официального репозитория MAX.
Настройки руля в этот профиль не включены.

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

## MAX

Первая установка MAX и его среды Flatpak требует интернета и может занять
несколько минут. При ошибке служба повторяет попытку через минуту.

```sh
journalctl -u install-max --no-pager -n 50
flatpak run ru.max.MAX
```

После первого включения Flatpak выйдите из GNOME и войдите снова, если MAX
не появился в меню. Последующие обновления MAX выполняются отдельно от NixOS:

```sh
sudo flatpak update --system ru.max.MAX
```

Если Steam не появился в Dock из-за сохранённых настроек пользователя:

```sh
gsettings reset org.gnome.shell favorite-apps
```

## Сон и NVIDIA

Для восстановления после S3 включено сохранение видеопамяти и службы
NVIDIA suspend/resume. Используется systemd-интерфейс вместо kernel suspend
notifier; временные данные видеопамяти сохраняются на диске в `/var/tmp`.
Оставляйте около 12 ГиБ свободного места на его файловой системе.

После изменения этих параметров выполните `nix-update` и перезагрузку.
Проверьте:

```sh
grep -E 'PreserveVideoMemoryAllocations|UseKernelSuspendNotifiers|TemporaryFilePath' /proc/driver/nvidia/params
systemctl status nvidia-suspend.service nvidia-resume.service --no-pager
df -h /var/tmp
```

До первого сна службы oneshot могут показывать inactive (dead).
Сохраните работу перед проверкой `systemctl suspend`.
При повторной ошибке:

```sh
sudo journalctl -b -k --no-pager | grep -Ei 'NVRM|Xid|suspend|resume|PM:'
sudo journalctl -b -u nvidia-suspend.service -u nvidia-resume.service --no-pager
```

Эта настройка относится к сну; гибернация на дисковый swap отдельно
не настроена. Исправление требует проверки на оборудовании.
