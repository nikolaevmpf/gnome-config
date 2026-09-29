# Домашний игровой компьютер zet

Планируемый профиль NixOS 26.05: общие модули `common.nix`,
`gnome.nix`, `gaming.nix` и отдельный модуль NVIDIA. Игровой
модуль включает Steam и GameMode.

Пока известны только имя `zet` и наличие NVIDIA. Чтобы выбрать
подходящий драйвер и создать загрузочную конфигурацию, нужны точная
модель видеокарты, разметка диска после установки и режим загрузки.
Сейчас `zet` не зарегистрирован в `flake.nix`; запуск
`nixos-rebuild --flake .#zet` до завершения профиля невозможен.

На существующей системе соберите:

```sh
hostnamectl
lspci -nnk | grep -A5 -E 'VGA compatible controller|3D controller|Display controller'
nvidia-smi 2>&1 | head -25
lsblk -f
findmnt -R /
test -d /sys/firmware/efi && echo UEFI || echo BIOS
```

Сообщите, будет ли NixOS устанавливаться на диск целиком, и нужен ли
сохранённый раздел другой системы. UUID VM и 02i0132 сюда не копировать.
