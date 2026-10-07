# Intel NUC nuc

Оборудование: NUC8i7HVK, Core i7-8809G, 32 ГБ ОЗУ, Intel HD 630
(i915), Radeon RX Vega M GH (amdgpu), Intel I219-LM/I210 Ethernet,
Intel Wireless 8265, UEFI.

Профиль .#nuc зарегистрирован в flake.nix. Общие модули:
modules/common.nix, modules/gnome.nix, modules/gaming.nix.
Набор приложений соответствует 02i0132, включая Steam, GameMode,
LibreOffice, Telegram, MAX, Obsidian, Pinta, Remmina, Transmission
и Amnezia VPN. VS Code и Zed не включены в эти профили.

UUID установленной NixOS:
- EFI: 2AE2-E8A4.
- Btrfs: fc64e8f1-e978-4846-87c6-18308d6a81ce.
- Подтома: @root, @home, @nix, @log.

Диски:
- NVMe 232,9 ГиБ: NixOS, EFI и Btrfs.
- NVMe 931,5 ГиБ: ext4 Data, UUID 0ae52be7-d75e-4044-8367-a8687251a8cb,
  монтируется в /mnt/Data.

План подтверждён: NixOS устанавливается с очисткой SSD 232,9 ГиБ;
диск Data 931,5 ГиБ сохраняется без форматирования.
Имена nvme0n1/nvme1n1 могут изменяться. Для выбора диска используйте
модель, размер и серийный номер. Этот профиль не содержит форматирования
; Data монтируется по UUID в /mnt/Data при обращении.
Права и содержимое Data не изменяются.

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
Профиль готов к первой сборке; работа на оборудовании ещё требует проверки.

## Первое применение

Сверьте UUID выше с lsblk -f. Затем:

```sh
git clone https://github.com/nikolaevmpf/gnome-config.git ~/gnome-config
cd ~/gnome-config
sudo nixos-rebuild boot --flake .#nuc
```

Если каталог уже существует, вместо клонирования выполните git pull --ff-only.
После успешной сборки выполните sudo reboot. После перезагрузки:

```sh
hostname
ls /mnt/Data
findmnt /mnt/Data
ls -l /dev/kvm
virsh -c qemu:///system list --all
```

Последующие изменения применяются командой nix-update.
До первого применения hostname nixos относится к базовой установке:
не запускайте автоматический выбор профиля, используйте явно .#nuc.
