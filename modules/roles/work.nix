{ pkgs, ... }:
{
  # Workstation role: office, notes, communication and remote access.
  # User-facing applications are managed in Home Manager.

  # Инструменты, которые использует Kimi Code CLI (и другие агенты) при работе
  # в терминале: GitHub CLI для работы с репозиториями/PR, jq для JSON,
  # unzip для распаковки, which для поиска команд.
  environment.systemPackages = with pkgs; [
    gh
    jq
    unzip
    which
  ];
}
