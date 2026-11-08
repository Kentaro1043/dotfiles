{
  config,
  lib,
  pkgs,
  ...
}: let
  remotePackages = lib.mapAttrs (name: url:
    pkgs.writeShellApplication {
      name = "mcp-${name}";
      runtimeInputs = [pkgs.coreutils pkgs.nodejs];
      text = ''
        LITELLM_API_KEY="$(cat ${lib.escapeShellArg config.sops.secrets.litellm-api-key.path})"
        export LITELLM_API_KEY
        export NODE_EXTRA_CA_CERTS=${../../certs/homelab-root-ca.crt}
        # shellcheck disable=SC2016
        exec npx --yes mcp-remote@0.1.38 ${lib.escapeShellArg url} \
          --allow-http --header 'Authorization:Bearer ''${LITELLM_API_KEY}'
      '';
    }) {
    grafana-cloud = "https://llm.internal.kentaro1043.com/grafana-cloud/mcp";
    grafana-trap = "https://llm.internal.kentaro1043.com/grafana-trap/mcp";
    grafana-work = "https://llm.internal.kentaro1043.com/grafana-work/mcp";
    traq = "https://llm.internal.kentaro1043.com/traq/mcp";
  };
in {
  imports = [./mcp-joplin.nix];

  home.packages = lib.attrValues remotePackages;
  sops.secrets.litellm-api-key = {};

  programs.mcp = {
    enable = true;
    servers =
      lib.mapAttrs' (name: package:
        lib.nameValuePair name {
          command = lib.getExe package;
        })
      remotePackages
      // {science-tokyo-syllabus.url = "https://syllabus.s.isct.ac.jp/mcp";};
  };
}
