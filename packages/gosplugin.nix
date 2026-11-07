{ pkgs }:
let
  payload = pkgs.stdenvNoCC.mkDerivation {
    pname = "gosplugin-payload";
    version = "1.3.19.0";
    src = pkgs.fetchurl {
      url = "https://gu-st.ru/content/Gosplugin/Gosplugin_Linux-Debian_Installer.deb.sh";
      hash = "sha256-+d4KPuvIU8EBM9BA2as5ljtQnf8+o8pjYhqOFjps4/U=";
    };
    nativeBuildInputs = [ pkgs.dpkg ];
    dontUnpack = true;
    dontFixup = true;
    installPhase = ''
      mkdir extracted root
      offset=$(grep -a -n '^PAYLOAD:$' "$src" | cut -d: -f1)
      tail -n +$((offset + 1)) "$src" | tar -x -C extracted
      dpkg-deb -x extracted/*.deb root
      mkdir -p "$out"
      cp -a root/opt/iitrust/gosuslugi_plugin "$out/"
    '';
  };
in
pkgs.buildFHSEnv {
  name = "gosplugin";
  targetPkgs = p: with p; [
    stdenv.cc.cc glibc libGL fontconfig freetype zlib glib dbus
    double-conversion pcsclite opensc
    xorg.libX11 xorg.libxcb xorg.libXext xorg.libXrender
    xorg.libXi xorg.libSM xorg.libICE xorg.libXcursor xorg.libXrandr
  ];
  extraBuildCommands = ''
    mkdir -p "$out/opt/iitrust"
    ln -s ${payload}/gosuslugi_plugin "$out/opt/iitrust/gosuslugi_plugin"
  '';
  runScript = pkgs.writeShellScript "gosplugin-start" ''
    export LD_LIBRARY_PATH="/opt/iitrust/gosuslugi_plugin/bin:/opt/iitrust/gosuslugi_plugin/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    export QT_PLUGIN_PATH=/opt/iitrust/gosuslugi_plugin/plugins
    export QT_QPA_PLATFORM=xcb
    exec /opt/iitrust/gosuslugi_plugin/bin/gosuslugi_plugin "$@"
  '';
}
