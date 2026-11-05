{
  config,
  lib,
  pkgs,
  ...
}: let
  grafanaCloud = pkgs.writeShellApplication {
    name = "mcp-grafana-cloud";
    runtimeInputs = [pkgs.coreutils pkgs.nodejs];
    text = ''
      LITELLM_API_KEY="$(cat ${lib.escapeShellArg config.sops.secrets.litellm-api-key.path})"
      export LITELLM_API_KEY
      # shellcheck disable=SC2016
      exec npx --yes mcp-remote@0.1.38 http://litellm.internal.kentaro1043.com/grafana-cloud/mcp \
        --allow-http --header 'Authorization:Bearer ''${LITELLM_API_KEY}'
    '';
  };
  grafanaTrap = pkgs.writeShellApplication {
    name = "mcp-grafana-trap-sakura";
    runtimeInputs = [pkgs.coreutils pkgs.nodejs];
    text = ''
      LITELLM_API_KEY="$(cat ${lib.escapeShellArg config.sops.secrets.litellm-api-key.path})"
      export LITELLM_API_KEY
      # shellcheck disable=SC2016
      exec npx --yes mcp-remote@0.1.38 http://litellm.internal.kentaro1043.com/grafana-trap/mcp \
        --allow-http --header 'Authorization:Bearer ''${LITELLM_API_KEY}'
    '';
  };
  grafanaWork = pkgs.writeShellApplication {
    name = "mcp-grafana-work";
    runtimeInputs = [pkgs.coreutils pkgs.nodejs];
    text = ''
      LITELLM_API_KEY="$(cat ${lib.escapeShellArg config.sops.secrets.litellm-api-key.path})"
      export LITELLM_API_KEY
      # shellcheck disable=SC2016
      exec npx --yes mcp-remote@0.1.38 http://litellm.internal.kentaro1043.com/grafana-work/mcp \
        --allow-http --header 'Authorization:Bearer ''${LITELLM_API_KEY}'
    '';
  };
in {
  imports = [./mcp-joplin.nix];

  home.packages = [grafanaCloud grafanaTrap grafanaWork];
  sops.secrets.litellm-api-key = {};

  programs.mcp = {
    enable = true;
    servers = {
      grafana-cloud.command = lib.getExe grafanaCloud;
      grafana-trap-sakura.command = lib.getExe grafanaTrap;
      grafana-work.command = lib.getExe grafanaWork;
      science-tokyo-syllabus.url = "https://syllabus.s.isct.ac.jp/mcp";
    };
  };
}
