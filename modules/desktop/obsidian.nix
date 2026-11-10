{ pkgs, ... }:
let
  # obsidian.md недоступен из сети nuc (timeout при скачивании иконки).
  # Тот же файл с web.archive.org; содержимое идентично,
  # поэтому hash (фиксированный выход fetchurl) сохраняем прежним.
  icon = pkgs.fetchurl {
    url = "https://web.archive.org/web/2024id_/https://obsidian.md/images/obsidian-logo-gradient.svg";
    hash = "sha256-EZsBuWyZ9zYJh0LDKfRAMTtnY70q6iLK/ggXlplDEoA=";
  };
in
{
  nixpkgs.overlays = [
    (_final: prev: {
      obsidian = prev.obsidian.overrideAttrs (old: {
        # installPhase уже содержит путь к исходной иконке. Меняем только его,
        # чтобы остальные исправления installPhase в nixpkgs сохранялись.
        installPhase = builtins.replaceStrings [ "${old.icon}" ] [ "${icon}" ] old.installPhase;
      });
    })
  ];
}
