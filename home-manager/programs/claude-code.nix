{
  lib,
  pkgs,
  llmAgentPackages,
  ...
}: let
  claudeCodeStatusline = pkgs.writeShellApplication {
    name = "claude-code-statusline";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gawk
      pkgs.git
      pkgs.jq
    ];
    text = builtins.readFile ./claude-code-statusline-command.sh;
  };
  claudeCodeNotify = pkgs.writeShellApplication {
    name = "claude-code-notify";
    runtimeInputs =
      [
        pkgs.coreutils
        pkgs.jq
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [pkgs.terminal-notifier]
      ++ lib.optionals pkgs.stdenv.isLinux [pkgs.libnotify];
    text = builtins.readFile ./claude-code-notify.sh;
  };
in {
  home.file.".claude/statusline-command.sh".source = lib.getExe claudeCodeStatusline;

  programs.claude-code = {
    enable = true;
    package = llmAgentPackages.claude-code;
    context = ./AGENTS.md;
    settings = {
      statusLine = {
        type = "command";
        command = "~/.claude/statusline-command.sh";
      };
      hooks = {
        PermissionRequest = [
          {
            matcher = "";
            hooks = [
              {
                type = "command";
                command = lib.getExe claudeCodeNotify;
              }
            ];
          }
        ];
        Stop = [
          {
            matcher = "";
            hooks = [
              {
                type = "command";
                command = lib.getExe claudeCodeNotify;
              }
            ];
          }
        ];
      };
    };
    mcpServers = {
      context7 = {
        command = "npx";
        args = [
          "-y"
          "@upstash/context7-mcp@latest"
        ];
      };
      #filesystem = {
      #  command = "npx";
      #  args =
      #    [
      #      "-y"
      #      "@modelcontextprotocol/server-filesystem"
      #    ]
      #    ++ lib.optionals pkgs.stdenv.isDarwin [
      #      "/Users/kentaro/source/repos"
      #    ]
      #    ++ lib.optionals pkgs.stdenv.isLinux [
      #      "/home/kentaro/source/repos"
      #    ];
      #};
      #fetch = {
      #  command = "uvx";
      #  args = [
      #    "mcp-server-fetch"
      #  ];
      #};
      #ddg-search = {
      #  command = "uvx";
      #  args = [
      #    "duckduckgo-mcp-server"
      #  ];
      #};
      #sequential-thinking = {
      #  command = "npx";
      #  args = [
      #    "-y"
      #    "@modelcontextprotocol/server-sequential-thinking"
      #  ];
      #};
      serena = {
        command = "uvx";
        args = [
          "--from"
          "git+https://github.com/oraios/serena"
          "serena"
          "start-mcp-server"
          "--context"
          "claude-code"
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
    };
  };
}
