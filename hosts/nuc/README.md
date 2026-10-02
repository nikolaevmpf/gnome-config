# Intel NUC nuc — подготовка

Оборудование: NUC8i7HVK, Core i7-8809G, 32 ГБ ОЗУ, Intel HD 630
(i915), Radeon RX Vega M GH (amdgpu), Intel I219-LM/I210 Ethernet,
Intel Wireless 8265, UEFI.

Подготовлены hardware.nix и apps.nix. Планируемые общие модули:
modules/common.nix, modules/gnome.nix, modules/gaming.nix.
Набор приложений соответствует 02i0132, включая Steam, GameMode,
LibreOffice, Telegram, MAX, Obsidian, Pinta, Remmina, Transmission
и Amnezia VPN. VS Code включён в nuc и 02i0132.

Загрузочный профиль пока не зарегистрирован в flake.nix.
Текущие UUID относятся к Arch и не используются как UUID новой NixOS.
После установки нужны lsblk -f и findmnt -t btrfs -o TARGET,SOURCE.

Обнаруженные диски Arch:
- NVMe 232,9 ГиБ: система Arch, EFI и Btrfs.
- NVMe 931,5 ГиБ: ext4 Data, UUID 0ae52be7-d75e-4044-8367-a8687251a8cb,
  монтируется в /mnt/Data.

План подтверждён: NixOS устанавливается с очисткой SSD 232,9 ГиБ;
диск Data 931,5 ГиБ сохраняется без форматирования.
Имена nvme0n1/nvme1n1 могут изменяться. Для выбора диска используйте
модель, размер и серийный номер. Этот профиль не содержит форматирования
или автоматического монтирования Data.

## QEMU/KVM

Модуль virtualisation.nix подключён через apps.nix: QEMU/KVM, libvirt,
virt-manager, virt-viewer, TPM через swtpm, общие папки через virtiofsd
и перенаправление USB через SPICE.
Пользователь nikolaev добавлен в группы libvirtd и kvm.
В BIOS/UEFI должна быть включена Intel Virtualization Technology (VT-x).

После первого применения готового профиля перезагрузитесь и проверьте:

```sh
ls -l /dev/kvm
virsh -c qemu:///system list --all
```

Для создания VM откройте Virtual Machine Manager в меню GNOME.
Подключение: QEMU/KVM system (qemu:///system).
Если сеть default не запущена, проверьте virsh -c qemu:///system net-list --all;
для существующей сети default включите net-autostart default и net-start default.
Операции virsh выполняются с -c qemu:///system.

Образы VM по умолчанию хранятся на системном диске в /var/lib/libvirt/images.
Перенос на Data нужно настроить отдельно после проверки его монтирования.
Профиль nuc пока ожидает UUID установленной NixOS и регистрацию в flake.nix.
