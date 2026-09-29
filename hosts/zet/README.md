# Домашний игровой компьютер zet

Профиль `.#zet` доступен в `flake.nix`. Он использует NixOS 26.05,
общие модули GNOME и игровой модуль (Steam, GameMode).

Оборудование: ZET Gaming WARD H264, GeForce RTX 4060 Ti (AD106).
При сборе сведений NixOS уже установлена в режиме UEFI:

- `/dev/sdb1` — EFI, UUID `1B70-3CD2`, точка монтирования `/boot`;
- `/dev/sdb2` — Btrfs, UUID `7bcd30d7-6ded-48b4-b17d-1160840adb72`,
  подтома `@root`, `@home`, `@nix`, `@log`;
- `/dev/sda` — отдельный Btrfs-диск с меткой `Data`, UUID
  `f9e98bf3-948b-4430-9996-d7b62f1487bd`. Он монтируется в `/games`
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
