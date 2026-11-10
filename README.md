# gnome-config

Декларативные конфигурации NixOS 26.05 с GNOME и Home Manager для нескольких машин.

## Профили

- `vm` — тестовая виртуальная машина QEMU с гостевыми службами и вложенной виртуализацией.
- `nuc` — домашняя рабочая машина: офисные приложения, Zed/Kimi, MAX и QEMU/KVM.
- `02i0132` — рабочая машина с NVIDIA: офисные приложения, Zed/Kimi, MAX, Steam и GameMode.
- `zet` — домашняя игровая машина с NVIDIA, Steam, GameMode, Boxflat и отдельным диском `/games`.
- `dell` — ноутбук: офисные приложения, QEMU/KVM, управление питанием и Thermald.

## Структура

- `flake.nix` — входы и состав ролей каждого профиля.
- `modules/base/` — сеть, звук, SSH, пользователь, очистка Nix и обслуживание дисков.
- `modules/desktop/` — GNOME, шрифты, Ghostty и переопределение иконки Obsidian.
- `modules/home/` — подключение Home Manager к NixOS.
- `modules/roles/` — необязательные роли: работа, игры, виртуализация, разработка и MAX.
- `hosts/<host>/` — оборудование, UUID дисков и специфичные параметры хоста.
- `home/common/` — общие GNOME, Dash to Dock, Ghostty, Astra Monitor и Zed.
- `home/hosts/` — пользовательские пакеты и Dock конкретной машины.

## Обновление настроенной машины

Репозиторий должен находиться в `~/gnome-config`, рабочая копия — на `main` и без незакоммиченных файлов.

```bash
nix-update
```

Команда получает `origin/main`, выполняет fast-forward при необходимости и запускает `nixos-rebuild switch` для текущего hostname. При расхождении локальной и удалённой истории она останавливается: rebase нужно выполнить вручную.

Для обновления версий всех входов:

```bash
nix-update --upgrade
```

Если команда изменила `flake.lock`, проверьте и опубликуйте его:

```bash
git diff -- flake.lock
git add flake.lock
git commit -m "Обновить flake.lock"
git push origin main
```

Ручной вариант:

```bash
cd ~/gnome-config
git pull --ff-only
sudo nixos-rebuild switch --flake ".#$(hostname)"
```

Для исходного hostname `nixos` явно указывайте нужный профиль вместо `$(hostname)`.

## Первое применение

1. Сверьте UUID и подтома с `lsblk -f` и `findmnt -t btrfs -o TARGET,SOURCE`.
2. Прочитайте README нужного хоста.
3. Создайте загрузочное поколение, не меняя текущую систему:

```bash
sudo nixos-rebuild boot --flake .#<profile>
```

4. Перезагрузитесь только после успешной сборки. При проблемах выберите предыдущее поколение в systemd-boot.

Конфигурация не форматирует диски.

## Обслуживание

- Nix еженедельно удаляет старые пути и оптимизирует хранилище; systemd-boot хранит до 10 поколений.
- Для системного Btrfs ежемесячно запускается scrub, для SSD — периодический TRIM.
- На физических машинах включён SMART, на ноутбуке Dell — Thermald.
- SSH доступен только с ключом: вход root и аутентификация по паролю запрещены.
- Поколения NixOS не заменяют резервное копирование `/home`; внешнюю копию данных нужно настраивать отдельно.

## Проверки

Проверка lock-файла, форматирования, statix, deadnix и оценки всех пяти профилей выполняется локально:

```bash
nix flake check
for host in vm nuc 02i0132 zet dell; do
  nix eval --raw ".#nixosConfigurations.$host.config.system.build.toplevel.drvPath"
  echo
done
```

Оценка не заменяет полную сборку и проверку на оборудовании.
