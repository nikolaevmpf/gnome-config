{ config, pkgs, ... }:
{
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "ru_RU.UTF-8";
  console.keyMap = "us";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Weekly cleanup removes unreferenced store paths and system generations
  # older than 30 days; recent generations remain available for rollback.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
  services.journald.extraConfig = "SystemMaxUse=500M";

  zramSwap.enable = true;
  services.fwupd.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  users.users.nikolaev = {
    isNormalUser = true;
    description = "NixOS administrator";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
  };

  environment.systemPackages = with pkgs; [
    git vim wget curl pciutils usbutils nmap mc gdu btop
    (pkgs.writeShellApplication {
      name = "nix-update";
      runtimeInputs = [ pkgs.git pkgs.nix pkgs.util-linux ];
      text = ''
        if [[ "$EUID" -eq 0 ]]; then
          echo "Запускай nix-update от обычного пользователя, без sudo." >&2
          exit 1
        fi
        
        upgrade=false
        case "''${1:-}" in
          "") ;;
          --upgrade) upgrade=true ;;
          --help|-h)
            echo "nix-update [--upgrade]: GitHub → сборка → применение."
            exit 0
            ;;
          *) echo "Использование: nix-update [--upgrade]" >&2; exit 1 ;;
        esac
        if [[ "$#" -gt 1 ]]; then
          echo "Использование: nix-update [--upgrade]" >&2
          exit 1
        fi
        
        repo="$HOME/gnome-config"
        if [[ ! -f "$repo/flake.nix" ]] || ! git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo "Не найден репозиторий $repo." >&2
          exit 1
        fi
        exec 9>"$repo/.git/nix-update.lock"
        flock -n 9 || { echo "Обновление уже запущено." >&2; exit 1; }
        cd "$repo"
        
        if [[ "$(git branch --show-current)" != main ]]; then
          echo "Переключись на ветку main перед обновлением." >&2
          exit 1
        fi
        if [[ -d "$(git rev-parse --git-path rebase-merge)" ]] ||
           [[ -d "$(git rev-parse --git-path rebase-apply)" ]] ||
           [[ -f "$(git rev-parse --git-path MERGE_HEAD)" ]]; then
          echo "Сначала заверши или отмени текущий rebase/merge. Проверь git status." >&2
          exit 1
        fi
        if ! git diff --quiet || ! git diff --cached --quiet; then
          echo "Есть незакоммиченные изменения. Проверь git status и сохрани правки коммитом перед обновлением." >&2
          exit 1
        fi
        echo "Получаю изменения из GitHub…"
        git fetch origin
        if ! git merge-base --is-ancestor origin/main HEAD; then
          if git merge-base --is-ancestor HEAD origin/main; then
            git merge --ff-only origin/main
          else
            backup="backup/nix-update-$(date +%Y%m%d-%H%M%S)-$(git rev-parse --short HEAD)"
            git branch "$backup"
            echo "Локальные коммиты сохранены в $backup. Переношу их поверх origin/main…"
            if ! git rebase origin/main; then
              echo "Конфликт: сборка не запущена. Выполни git status." >&2
              echo "После исправления: git add <файлы> и git rebase --continue." >&2
              echo "Для отмены: git rebase --abort. Исходные коммиты сохранены в $backup." >&2
              exit 1
            fi
          fi
        fi
        
        if "$upgrade"; then
          echo "Обновляю версии пакетов в flake.lock…"
          nix flake update --flake "path:$repo"
        fi
        
        # Создать недостающий lock от пользователя, сохранив существующие версии.
        nix flake lock "path:$repo"
        
        echo "Применяю профиль ${if config.networking.hostName == "nixos" then "vm" else config.networking.hostName}…"
        /run/wrappers/bin/sudo /run/current-system/sw/bin/nixos-rebuild switch --flake "path:$repo#${if config.networking.hostName == "nixos" then "vm" else config.networking.hostName}"
        echo "Обновление завершено."
        
      '';
    })
  ];

  # Keep the state version from the original installation.
  system.stateVersion = "26.05";
}
