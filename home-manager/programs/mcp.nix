{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./mcp-joplin.nix];

  home.packages = [
    (pkgs.runCommand "grafana-mcp-commands" {} ''
      mkdir -p "$out/bin"
      ln -s ${config.programs.mcp.servers.grafana-cloud.command} "$out/bin/mcp-grafana-cloud"
      ln -s ${config.programs.mcp.servers.grafana-trap-sakura.command} "$out/bin/mcp-grafana-trap-sakura"
      ln -s ${config.programs.mcp.servers.grafana-work.command} "$out/bin/mcp-grafana-work"
    '')
  ];
  sops.secrets.litellm-api-key = {};

  programs.mcp = {
    enable = true;
    servers = {
      grafana-cloud.command = lib.getExe (pkgs.writeShellApplication {
        name = "mcp-grafana-cloud";
        runtimeInputs = [pkgs.coreutils pkgs.nodejs];
        text = ''
          LITELLM_API_KEY="$(cat ${lib.escapeShellArg config.sops.secrets.litellm-api-key.path})"
          export LITELLM_API_KEY
          # shellcheck disable=SC2016
          exec npx --yes mcp-remote@0.1.38 http://litellm.internal.kentaro1043.com/grafana-cloud/mcp \
            --allow-http --header 'Authorization:Bearer ''${LITELLM_API_KEY}'
        '';
      });
      grafana-trap-sakura.command = lib.getExe (pkgs.writeShellApplication {
        name = "mcp-grafana-trap-sakura";
        runtimeInputs = [pkgs.coreutils pkgs.nodejs];
        text = ''
          LITELLM_API_KEY="$(cat ${lib.escapeShellArg config.sops.secrets.litellm-api-key.path})"
          export LITELLM_API_KEY
          # shellcheck disable=SC2016
          exec npx --yes mcp-remote@0.1.38 http://litellm.internal.kentaro1043.com/grafana-trap/mcp \
            --allow-http --header 'Authorization:Bearer ''${LITELLM_API_KEY}'
        '';
      });
      grafana-work.command = lib.getExe (pkgs.writeShellApplication {
        name = "mcp-grafana-work";
        runtimeInputs = [pkgs.coreutils pkgs.nodejs];
        text = ''
          LITELLM_API_KEY="$(cat ${lib.escapeShellArg config.sops.secrets.litellm-api-key.path})"
          export LITELLM_API_KEY
          # shellcheck disable=SC2016
          exec npx --yes mcp-remote@0.1.38 http://litellm.internal.kentaro1043.com/grafana-work/mcp \
            --allow-http --header 'Authorization:Bearer ''${LITELLM_API_KEY}'
        '';
      });
      science-tokyo-syllabus.url = "https://syllabus.s.isct.ac.jp/mcp";
    };
  };
}
