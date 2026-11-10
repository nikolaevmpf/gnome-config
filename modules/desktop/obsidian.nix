{ ... }:
{
  # obsidian.md недоступен из сети nuc (timeout при скачивании иконки).
  # Заменяем URL иконки на web.archive.org; содержимое идентично,
  # поэтому hash (фиксированный выход fetchurl) сохраняем прежним.
  nixpkgs.overlays = [
    (final: prev: {
      obsidian = prev.obsidian.overrideAttrs (old: {
        icon = prev.fetchurl {
          url = "https://web.archive.org/web/2024id_/https://obsidian.md/images/obsidian-logo-gradient.svg";
          hash = "sha256-EZsBuWyZ9zYJh0LDKfRAMTtnY70q6iLK/ggXlplDEoA=";
        };
        # installPhase уже интерполирован с исходным icon на этапе
        # определения пакета, поэтому переписываем его целиком
        # (копия из nixpkgs с заменой ${icon} на переопределённый).
        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin

          # Mark Obsidian's app:// scheme `corsEnabled` to fix the internal PDF
          # viewer; see https://github.com/NixOS/nixpkgs/pull/525772 for details.
          # Remove once upstream registers the scheme with `corsEnabled`.
          asar extract resources/app.asar app-src
          substituteInPlace app-src/main.js \
            --replace-fail "supportFetchAPI: true," "supportFetchAPI: true, corsEnabled: true,"
          asar pack app-src resources/app.asar

          makeWrapper ${final.electron}/bin/electron $out/bin/obsidian \
            --add-flags $out/share/obsidian/app.asar \
            --add-flags "''${NIXOS_OZONE_WL:+''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime=true --wayland-text-input-version=3}}"
          install -m 755 -D obsidian-cli $out/bin/obsidian-cli
          install -m 444 -D resources/app.asar $out/share/obsidian/app.asar
          install -m 444 -D resources/obsidian.asar $out/share/obsidian/obsidian.asar
          install -m 444 -D "${old.desktopItem}/share/applications/"* \
            -t $out/share/applications/
          for size in 16 24 32 48 64 128 256 512; do
            mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
            magick -background none $out/share/icons/obsidian-src.svg -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/obsidian.png
          done
          runHook postInstall
        '';

        postInstall = ''
          runHook prePostInstall
          cp ${final.obsidian.icon} $out/share/icons/obsidian-src.svg
          runHook postPostInstall
        '';
      });
    })
  ];
}
