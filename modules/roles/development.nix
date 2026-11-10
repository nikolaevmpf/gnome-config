{ inputs, ... }:
{
  # Zed настраивается в Home Manager на хостах с этой ролью.
  # Kimi Code CLI нужен его ACP-интеграции (`kimi acp`).
  home-manager.users.nikolaev.home.packages = [
    inputs.kimi-code.packages.x86_64-linux.default
  ];
}
