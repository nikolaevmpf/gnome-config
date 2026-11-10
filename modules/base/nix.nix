{ config, pkgs, ... }:
let
  profile = if config.networking.hostName == "nixos" then "vm" else config.networking.hostName;
in
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "nix-update";
      runtimeInputs = with pkgs; [
        coreutils
        git
        nix
        util-linux
      ];
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
            echo "--upgrade дополнительно обновляет входы в flake.lock."
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
        if [[ -n "$(git status --porcelain --untracked-files=normal)" ]]; then
          echo "Есть незакоммиченные или неотслеживаемые файлы. Проверь git status." >&2
          echo "Сохрани или удали их перед обновлением." >&2
          exit 1
        fi

        echo "Получаю изменения из GitHub…"
        git fetch origin main
        if git merge-base --is-ancestor origin/main HEAD; then
          :
        elif git merge-base --is-ancestor HEAD origin/main; then
          git merge --ff-only origin/main
        else
          echo "Локальная main и origin/main разошлись. Автоматический rebase отменён." >&2
          echo "Проверь изменения и выполни git rebase origin/main вручную, затем повтори обновление." >&2
          exit 1
        fi

        if "$upgrade"; then
          echo "Обновляю версии пакетов в flake.lock…"
          nix flake update --flake "path:$repo"
        fi

        # Создать недостающий lock от пользователя, сохранив существующие версии.
        nix flake lock "path:$repo"

        echo "Применяю профиль ${profile}…"
        /run/wrappers/bin/sudo /run/current-system/sw/bin/nixos-rebuild switch --flake "path:$repo#${profile}"
        echo "Обновление завершено."

        if ! git diff --quiet -- flake.lock; then
          echo
          echo "flake.lock изменён. Проверь diff и опубликуй его, чтобы версии совпадали на всех машинах:"
          echo "  git diff -- flake.lock"
          echo "  git add flake.lock && git commit -m 'Обновить flake.lock' && git push origin main"
        fi
      '';
    })
  ];
}
