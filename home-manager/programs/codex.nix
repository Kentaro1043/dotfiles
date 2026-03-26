{pkgs, ...}: {
  programs.codex = {
    enable = true;
    package = pkgs.codex-latest;
    settings = {
      model = "gpt-oss:120b-cloud";
      model_context_window = 128000;
      model_provider = "ollama";
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
  };
}
