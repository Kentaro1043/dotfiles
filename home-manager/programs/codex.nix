{pkgs, ...}: {
  programs.codex = {
    enable = true;
    package = pkgs.codex-bin;
    settings = {
      model = "gpt-oss:120b-cloud";
      review_model = "gpt-oss:20b-cloud";
      model_provider = "ollama";
      approval_policy = "untrusted";
      model_providers = {
        ollama = {
          name = "ollama";
          base_url = "http://localhost:11434/v1";
          wire_api = "responses";
        };
      };
      mcp_servers = {
        context7 = {
          command = "npx";
          args = ["-y" "@upstash/context7-mcp"];
        };
        filesystem = {
          command = "npx";
          args = ["-y" "@modelcontextprotocol/server-filesystem" "/home/kentaro/source/repos"];
        };
        fetch = {
          command = "uvx";
          args = ["mcp-server-fetch"];
        };
        ddg-search = {
          command = "uvx";
          args = ["duckduckgo-mcp-server"];
        };
        sequential-thinking = {
          command = "npx";
          args = ["-y" "@modelcontextprotocol/server-sequential-thinking"];
        };
        serena = {
          command = "uvx";
          args = ["--from" "git+https://github.com/oraios/serena" "serena" "start-mcp-server" "--context" "ide" "--project-from-cwd"];
        };
      };
    };
  };
}
