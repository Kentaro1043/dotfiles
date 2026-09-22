{
  grafanaMcpCommands,
  pkgs,
  lib,
  inputs,
  llmAgentPackages,
  ...
}: let
  codexConfig = pkgs.writeText "codex-config.toml" (
    builtins.replaceStrings
    ["@grafanaWorkCommand@" "@grafanaTrapSakuraCommand@" "@grafanaTrapConohaCommand@"]
    [grafanaMcpCommands.work grafanaMcpCommands.trap-sakura grafanaMcpCommands.trap-conoha]
    (builtins.readFile ./codex-config.toml)
  );
  codexHomes = [
    ".codex"
    ".codex-work"
  ];
  skills = import ./agent-skills.nix {inherit inputs;};
in {
  programs.codex = {
    enable = true;
    package = llmAgentPackages.codex;
    context = ./AGENTS.md;
  };

  home.file = lib.listToAttrs (
    lib.concatMap (
      codexHome:
        map (skill:
          lib.nameValuePair "${codexHome}/skills/${skill.name}" {
            inherit (skill) source;
            force = true;
          })
        skills
    )
    codexHomes
  );

  home.activation.setupCodexConfig = lib.hm.dag.entryAfter ["writeBoundary"] (
    lib.concatMapStringsSep "\n" (codexHome: ''
      $DRY_RUN_CMD mkdir -p "$HOME/${codexHome}"
      $DRY_RUN_CMD rm -f "$HOME/${codexHome}/config.toml"
      $DRY_RUN_CMD cp ${codexConfig} "$HOME/${codexHome}/config.toml"
      $DRY_RUN_CMD chmod 644 "$HOME/${codexHome}/config.toml"
    '')
    codexHomes
  );
}
