{ ... }:
{
  # Zed с интеграцией Kimi Code CLI через ACP (Agent Client Protocol).
  # Zed запускает `kimi acp` как подпроцесс; аутентификация переиспользуется
  # из CLI (нужен один раз выполнить `kimi` → /login).
  programs.zed-editor = {
    enable = true;

    # Zed не скачивает LSP-бинарники сам, если они есть в extraPackages.
    extensions = [
      "nix"
      "toml"
    ];

    userSettings = {
      agent_servers."Kimi Code CLI" = {
        type = "custom";
        command = "kimi";
        args = [ "acp" ];
        env = { };
      };

      auto_install_extensions = true;
      auto_update = false;

      terminal = {
        shell = "system";
        working_directory = "current_project_directory";
      };

      lsp.nix.binary.path_lookup = true;
    };
  };
}
