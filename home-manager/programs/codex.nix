{
  pkgs,
  lib,
  ...
}: {
  programs.codex = {
    enable = true;
    package = pkgs.codex-bin;
    # config.tomlがRead-Onlyだと困るので、activationで対応
    /**
    settings = {
      model = "gpt-5.4";
      # model_context_window = 128000;
      # model_provider = "ollama-custom";
      approval_policy = "untrusted";
      web_search = "live";
      model_providers = {
        ollama-custom = {
          name = "ollama-custom";
          base_url = "http://localhost:11434/v1";
          wire_api = "responses";
        };
      };
      mcp_servers = {
        context7 = {
          command = "npx";
          args = ["-y" "@upstash/context7-mcp"];
        };
        serena = {
          command = "uvx";
          args = [
            "--from"
            "git+https://github.com/oraios/serena"
            "serena"
            "start-mcp-server"
            "--context"
            "codex"
            "--project-from-cwd"
            "--enable-web-dashboard"
            "false"
          ];
        };
        exa = {
          url = "https://mcp.exa.ai/mcp";
        };
      };
    };
    */
  };
  home.activation.setupCodexConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $HOME/.codex
    $DRY_RUN_CMD rm -f $HOME/.codex/config.toml
    $DRY_RUN_CMD cp ${./codex-config.toml} $HOME/.codex/config.toml
    $DRY_RUN_CMD chmod 644 $HOME/.codex/config.toml
  '';
}
