{...}: {
  programs.mcp = {
    enable = true;
    servers = {
      context7 = {
        command = "npx";
        args = [
          "-y"
          "@upstash/context7-mcp@latest"
        ];
      };
      ddg-search = {
        command = "uvx";
        args = [
          "duckduckgo-mcp-server"
        ];
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
      codex = {
        command = "codex";
        args = [
          "mcp-server"
        ];
      };
      # sequential-thinking = {
      #   command = "npx";
      #   args = [
      #     "-y"
      #     "@modelcontextprotocol/server-sequential-thinking"
      #   ];
      # };
      # filesystem = {
      #   command = "npx";
      #   args =
      #     [
      #       "-y"
      #       "@modelcontextprotocol/server-filesystem"
      #     ]
      #     ++ lib.optionals pkgs.stdenv.isDarwin [
      #       "/Users/kentaro/source/repos"
      #     ]
      #     ++ lib.optionals pkgs.stdenv.isLinux [
      #       "/home/kentaro/source/repos"
      #     ];
      # };
      # fetch = {
      #   command = "uvx";
      #   args = [
      #     "mcp-server-fetch"
      #   ];
      # };
    };
  };
}
