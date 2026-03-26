{pkgs, ...}: {
  programs.codex = {
    enable = true;
    package = pkgs.codex-latest;
    settings = {
      model = "gpt-oss:120b-cloud";
      review_model = "gpt-oss:20b-cloud";
      model_provider = "ollama";
      approval_policy = "untrusted";
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
        ddg-search = {
          command = "uvx";
          args = ["duckduckgo-mcp-server"];
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
      };
    };
  };
}
