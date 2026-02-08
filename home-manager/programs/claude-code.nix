{
  pkgs,
  lib,
  ...
}: {
  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;
    mcpServers = {
      context7 = {
        type = "stdio";
        command = "npx";
        args = [
          "-y"
          "@upstash/context7-mcp@latest"
        ];
      };
      filesystem = {
        type = "stdio";
        command = "npx";
        args =
          [
            "-y"
            "@modelcontextprotocol/server-filesystem"
          ]
          ++ lib.optionals pkgs.stdenv.isDarwin [
            "/Users/kentaro/source/repos"
          ]
          ++ lib.optionals pkgs.stdenv.isLinux [
            "/home/kentaro/source/repos"
          ];
      };
      fetch = {
        type = "stdio";
        command = "uvx";
        args = [
          "mcp-server-fetch"
        ];
      };
      sequential-thinking = {
        type = "stdio";
        command = "npx";
        args = [
          "-y"
          "@modelcontextprotocol/server-sequential-thinking"
        ];
      };
    };
  };
}
