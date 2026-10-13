# Home Manager во всех профилях

Home Manager release-26.05 подключён как модуль NixOS; nixpkgs следует системному input.
Профили vm, zet, nuc, 02i0132 и dell используют home/nikolaev.nix для nikolaev.

## Где редактировать

- home/hosts/<профиль>-gnome.nix: тема, фон, раскладки, горячие клавиши и настройки GNOME этого хоста.
- home/hosts/<профиль>-dock.nix: Dash to Dock, закреплённые приложения и расширение этого хоста.
- home/hosts/<профиль>.nix: приложения (home.packages), настройки Ghostty (ghosttyConfig) и импорты этого хоста.
- home/nikolaev.nix: учётная запись Home Manager и выбор профиля по hostname.
- hosts/<профиль>: диски, драйверы, службы, виртуализация, автологин.
- modules/common.nix: сеть, firewall, SSH, звук, очистка и nix-update.

Steam/GameMode, MAX/Flatpak, Amnezia, libvirt и правила MOZA остаются в NixOS:
они требуют системной интеграции. Boxflat, офис, редакторы и Transmission перенесены в Home Manager.
Ghostty и Firefox доступны всем пяти профилям. direnv не добавлен.

## Первое применение миграции

Сохраните работу. Выполняйте от nikolaev:

```bash
cd ~/gnome-config
git pull --ff-only
nix flake lock "path:$PWD"
sudo nixos-rebuild build --flake "path:$PWD#$(hostname | sed 's/^nixos$/vm/')"
```

После успешной сборки:

```bash
sudo nixos-rebuild switch --flake "path:$PWD#$(hostname | sed 's/^nixos$/vm/')"
systemctl status home-manager-nikolaev.service --no-pager
```

Эти команды предназначены для уже применённых host-профилей. На новой базовой установке
укажите профиль явно (например #dell); hostname nixos выбирает VM.
Если flake.lock принадлежит root: sudo chown nikolaev:users flake.lock.
Lock добавляет Home Manager, сохраняя существующий pin nixpkgs; --upgrade для миграции не требуется.

После применения выйдите из GNOME и войдите снова. Далее достаточно nix-update.
Отдельный home-manager switch использовать не нужно.

## Личные настройки и резервные копии

Существующие файлы Ghostty config и config.ghostty при конфликте сохраняются рядом
как *.hm-backup-<время>. Home Manager управляет обоими именами и заменяет старый include
/etc/ghostty/<хост>.conf. Старый ghostty-host-config.service удалён.
Не редактируйте символические ссылки ~/.config/ghostty: меняйте исходный файл в репозитории.
Начальные настройки всех хостов сохранены. Каждый хост теперь имеет собственные значения GNOME, Dock и Ghostty.
Изменение home/hosts/dell-dock.nix влияет только на dell; остальные профили не импортируют этот файл.

dconf теперь записывает выбранные ключи в пользовательскую базу при активации.
Изменения этих ключей в настройках GNOME могут быть перезаписаны следующим обновлением.
Перед миграцией при желании сохраните базу: dconf dump / > ~/dconf-before-home-manager.ini.
Прочие файлы, документы, SSH-ключи и настройки приложений не удаляются.

## Проверка и откат

При ошибке активации: journalctl -u home-manager-nikolaev.service -b --no-pager.
Для отката системы: sudo nixos-rebuild switch --rollback.
Откат поколения не восстанавливает пользовательскую базу dconf и файлы из резервных копий автоматически.
Сборка и активация на оборудовании пока не проверены; здесь выполнена проверка структуры модулей.

## Независимые настройки хостов

Для vm, zet, nuc, 02i0132 и dell выделены собственные файлы. Например, для Dell:

- `home/hosts/dell-gnome.nix` — оформление, фон, раскладки и сочетания клавиш.
- `home/hosts/dell-dock.nix` — положение, автоскрытие, прозрачность и favorite-apps.
- `home/hosts/dell.nix` — программы и настройки Ghostty.
- `hosts/dell/default.nix` и его импорты — системные настройки и оборудование.

Чтобы переместить Dock Dell влево, поменяйте `dock-position = "BOTTOM";` на `dock-position = "LEFT";` только в `dell-dock.nix`.
После сохранения коммита примените `nix-update` на Dell. Для других машин меняйте файлы с их именем.
`--upgrade` для изменения настроек не нужен. Изменения общих модулей `modules/` по-прежнему затрагивают использующие их хосты.

## Astra Monitor

Astra Monitor включён на `02i0132`, `zet`, `nuc` и `dell`. На `vm` не устанавливается.
Каждый хост импортирует собственный `home/hosts/<хост>-monitoring.nix`.
Vitals удалён. Применение на каждом компьютере: `nix-update`, затем выйти из GNOME и войти снова.
Показатели настраиваются через «Расширения» → Astra Monitor → настройки.
