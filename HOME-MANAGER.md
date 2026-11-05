# Home Manager

Home Manager подключён как модуль NixOS и используется для пользователя `nikolaev`.

## Структура

- `home/nikolaev.nix` — базовая home-конфигурация и выбор профиля по hostname.
- `home/common/gnome.nix` — общие настройки GNOME.
- `home/common/dock.nix` — общие настройки Dash to Dock.
- `home/common/ghostty.nix` — общий конфиг Ghostty.
- `home/common/monitoring.nix` — Astra Monitor.
- `home/hosts/<host>.nix` — отличия конкретного хоста.

## Логика

Общие настройки вынесены в `home/common/`, чтобы не дублировать одинаковые блоки между машинами.
В `home/hosts/` остаются только:
- набор пользовательских пакетов,
- favorite-apps,
- импорт monitoring-настроек, если нужен.

## Применение

После изменений:

```bash
nix flake lock
sudo nixos-rebuild switch --flake .#<profile>
```

Затем выйти из GNOME и войти снова, если менялись dconf-настройки.

## Поведение

Home Manager управляет конфигурационными файлами Ghostty и dconf-настройками.
При конфликте существующие файлы сохраняются с суффиксом `.hm-backup-<время>`.
