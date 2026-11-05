{
  config,
  lib,
  pkgs,
  ...
}: let
  grafanaPackages = lib.mapAttrs (name: url:
    pkgs.writeShellApplication {
      name = "mcp-grafana-${name}";
      runtimeInputs = [pkgs.coreutils pkgs.nodejs];
      text = ''
        LITELLM_API_KEY="$(cat ${lib.escapeShellArg config.sops.secrets.litellm-api-key.path})"
        export LITELLM_API_KEY
        # shellcheck disable=SC2016
        exec npx --yes mcp-remote@0.1.38 ${lib.escapeShellArg url} \
          --allow-http --header 'Authorization:Bearer ''${LITELLM_API_KEY}'
      '';
    }) {
    cloud = "https://llm.internal.kentaro1043.com/grafana-cloud/mcp";
    trap = "https://llm.internal.kentaro1043.com/grafana-trap/mcp";
    work = "https://llm.internal.kentaro1043.com/grafana-work/mcp";
  };
in {
  imports = [./mcp-joplin.nix];

  home.packages = lib.attrValues grafanaPackages;
  sops.secrets.litellm-api-key = {};

  programs.mcp = {
    enable = true;
    servers =
      lib.mapAttrs' (name: package:
        lib.nameValuePair "grafana-${name}" {
          command = lib.getExe package;
        })
      grafanaPackages
      // {science-tokyo-syllabus.url = "https://syllabus.s.isct.ac.jp/mcp";};
  };
}
