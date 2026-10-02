# Intel NUC nuc — подготовка

Оборудование: NUC8i7HVK, Core i7-8809G, 32 ГБ ОЗУ, Intel HD 630
(i915), Radeon RX Vega M GH (amdgpu), Intel I219-LM/I210 Ethernet,
Intel Wireless 8265, UEFI.

Подготовлены hardware.nix и apps.nix. Планируемые общие модули:
modules/common.nix, modules/gnome.nix, modules/gaming.nix.
Набор приложений соответствует 02i0132, включая Steam, GameMode,
LibreOffice, Telegram, MAX, Obsidian, Pinta, Remmina, Transmission
и Amnezia VPN. VS Code пока исключён, как на 02i0132.

Загрузочный профиль пока не зарегистрирован в flake.nix.
Текущие UUID относятся к Arch и не используются как UUID новой NixOS.
После установки нужны lsblk -f и findmnt -t btrfs -o TARGET,SOURCE.

Обнаруженные диски Arch:
- NVMe 232,9 ГиБ: система Arch, EFI и Btrfs.
- NVMe 931,5 ГиБ: ext4 Data, UUID 0ae52be7-d75e-4044-8367-a8687251a8cb,
  монтируется в /mnt/Data.

До установки подтвердите целевой системный диск и судьбу Data.
Имена nvme0n1/nvme1n1 могут изменяться. Для выбора диска используйте
модель, размер и серийный номер. Этот профиль не содержит форматирования
или автоматического монтирования Data.
