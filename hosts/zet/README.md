# Домашний игровой компьютер zet

Профиль `.#zet` доступен в `flake.nix`. Он использует NixOS 26.05,
общие модули GNOME и игровой модуль (Steam, GameMode).

Оборудование: ZET Gaming WARD H264, GeForce RTX 4060 Ti (AD106).
При сборе сведений NixOS уже установлена в режиме UEFI:

- Системный EFI-раздел —, UUID `1B70-3CD2`, точка монтирования `/boot`;
- Системный Btrfs-раздел —, UUID `7bcd30d7-6ded-48b4-b17d-1160840adb72`,
  подтома `@root`, `@home`, `@nix`, `@log`;
- Отдельный Btrfs-диск с меткой `Data`, UUID
  `20b6bd92-e375-402e-a18c-abe43cf65b79`. Он монтируется в `/games`
  без форматирования при первом обращении. Если диск недоступен, загрузка
  системы продолжается. Каталог библиотеки создаётся вручную после проверки диска.

## Первое применение

Сверьте UUID по `lsblk -f`. Затем в установленной NixOS:

```sh
git clone https://github.com/nikolaevmpf/gnome-config.git ~/gnome-config
cd ~/gnome-config
nix flake lock
git add flake.lock
sudo nixos-rebuild build --flake .#zet
sudo nixos-rebuild boot --flake .#zet
sudo reboot
```

Если каталог уже существует, вместо `git clone` выполните
`git pull --ff-only`. Не переходите к `boot`, если `build`
завершился ошибкой. Предыдущее поколение оставьте в меню загрузки
до проверки GNOME, NVIDIA и Btrfs.

После перезагрузки проверьте:

```sh
nvidia-smi
findmnt / /home /nix /var/log /boot /games
```

Для последующих изменений используйте
`sudo nixos-rebuild switch --flake .#zet`.

Сначала проверьте наличие диска командой `lsblk -f`, затем активируйте
монтирование и создайте библиотеку:

```sh
ls /games
findmnt /games
sudo install -d -o nikolaev -g users -m 0755 /games/SteamLibrary
```

Если `findmnt /games` не показывает Btrfs-диск `Data`, не создавайте
библиотеку. В Steam откройте **Настройки → Хранилище**, добавьте каталог
`/games/SteamLibrary` и назначьте его библиотекой по умолчанию.
Без этого Steam продолжит устанавливать игры в домашний каталог.

## Руль MOZA R3

Модуль `moza.nix` подключён только в профиле `zet`. Используется встроенный
драйвер ядра `hid-universal-pidff` для силовой обратной связи (FFB),
приложение Boxflat и поставляемые с ним правила udev для доступа к устройствам.
Поддержка драйвера есть в Linux 6.15 и новее, включая используемое ядро 6.18.
Boxflat позволяет менять настройки базы, руля и педалей; работа FFB в игре
также зависит от самой игры и версии Proton.

После обновления конфигурации:

```sh
cd ~/gnome-config
git pull --ff-only
sudo nixos-rebuild switch --flake .#zet
```

Переподключите USB-кабель базы, включите её и запустите **Boxflat** из меню
GNOME или командой `boxflat`. Запускайте приложение от обычного пользователя.
Если драйвер не подхватился после применения, перезагрузите компьютер.

Для диагностики с подключённым рулём:

```sh
lsusb -d 346e:
lsmod | grep -E 'hid_universal_pidff|cdc_acm'
sudo journalctl -k -b --no-pager | grep -Ei 'moza|pidff|346e|ttyACM'
```

Исходные проекты: [Boxflat](https://github.com/Lawstorant/boxflat) и
[драйвер universal-pidff](https://github.com/JacKeTUs/universal-pidff).

## Сон и восстановление NVIDIA

Включено сохранение видеопамяти и службы NVIDIA suspend/resume,
как в профиле `02i0132`. Снимок видеопамяти хранится на диске в `/var/tmp`.
После применения новых параметров нужна перезагрузка:

```sh
nix-update
sudo reboot
```

Если команда `nix-update` ещё не установлена:

```sh
cd ~/gnome-config
git pull --ff-only
sudo nixos-rebuild switch --flake .#zet
sudo reboot
```

После загрузки проверьте настройки и свободное место:

```sh
grep -E 'PreserveVideoMemoryAllocations|UseKernelSuspendNotifiers|TemporaryFilePath' /proc/driver/nvidia/params
df -h /var/tmp
nvidia-smi --query-gpu=memory.total --format=csv
```

Для снимка оставляйте свободное место не меньше объёма видеопамяти
плюс около 5% запаса. Сохраните работу перед проверкой `systemctl suspend`.
Эта настройка требует проверки на оборудовании и не настраивает гибернацию.

При повторной проблеме после перезагрузки соберите предыдущий журнал:

```sh
sudo journalctl -b -1 -k --no-pager | grep -Ei 'NVRM|Xid|suspend|resume|PM:'
sudo journalctl -b -1 -u nvidia-suspend.service -u nvidia-resume.service --no-pager
```
