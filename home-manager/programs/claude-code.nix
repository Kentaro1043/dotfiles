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
  claudeCodeSettings = {
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
  claudeCodeSettingsFile =
    (pkgs.formats.json {}).generate "claude-code-settings.json" claudeCodeSettings;
in {
  home.file.".claude/statusline-command.sh".source = lib.getExe claudeCodeStatusline;

  home.activation.setupClaudeCodeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $HOME/.claude
    $DRY_RUN_CMD rm -f $HOME/.claude/settings.json
    $DRY_RUN_CMD cp ${claudeCodeSettingsFile} $HOME/.claude/settings.json
    $DRY_RUN_CMD chmod 644 $HOME/.claude/settings.json
  '';

  programs.claude-code = {
    enable = true;
    package = llmAgentPackages.claude-code;
    context = ./AGENTS.md;
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
