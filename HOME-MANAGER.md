# Home Manager

Home Manager подключён как модуль NixOS и управляет конфигурацией пользователя `nikolaev`. Пакеты используют системный `nixpkgs`, поэтому версии и разрешение unfree совпадают с NixOS.

## Структура

- `home/nikolaev.nix` — общая конфигурация и выбор файла хоста по hostname.
- `home/common/gnome.nix` — тема, раскладки, фон, клавиша запуска Ghostty и Firefox.
- `home/common/dock.nix` — Dash to Dock.
- `home/common/ghostty.nix` — `~/.config/ghostty/config`.
- `home/common/monitoring.nix` — Astra Monitor.
- `home/common/zed.nix` — Zed и ACP-интеграция с Kimi Code CLI.
- `home/hosts/<host>.nix` — пакеты, избранные приложения и необязательные общие модули.

Hostname `nixos` соответствует Home Manager-профилю `vm`. Zed подключается только на `nuc` и `02i0132`; системная роль `development` одновременно устанавливает `kimi`, необходимый для `kimi acp`.

Для первого входа в Kimi Code запустите `kimi` и выполните `/login`.

## Применение

```bash
nix-update
```

Или вручную:

```bash
sudo nixos-rebuild switch --flake .#<profile>
```

После изменения dconf или списка расширений выйдите из GNOME и войдите снова. Управляемые Home Manager ключи перезаписывают ручные изменения через `gsettings`.

При конфликте существующий файл сохраняется с суффиксом `.hm-backup-<время>`. Резервные копии периодически проверяйте и удаляйте вручную.
