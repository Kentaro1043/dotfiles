{
  pkgs,
  lib,
  ...
}: {
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
      filesystem = {
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
        command = "uvx";
        args = [
          "mcp-server-fetch"
        ];
      };
      ddg-search = {
        command = "uvx";
        args = [
          "duckduckgo-mcp-server"
        ];
      };
      sequential-thinking = {
        command = "npx";
        args = [
          "-y"
          "@modelcontextprotocol/server-sequential-thinking"
        ];
      };
    };
  };
}
