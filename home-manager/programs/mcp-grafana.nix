{
  config,
  lib,
  pkgs,
  ...
}: let
  secretPrefixes = {
    work = "grafana-mcp-work";
  };
  localPackages = lib.mapAttrs (name: prefix:
    pkgs.writeShellApplication {
      name = "mcp-grafana-${name}";
      runtimeInputs = [pkgs.coreutils pkgs.uv];
      text = ''
        GRAFANA_URL="$(cat ${lib.escapeShellArg config.sops.secrets."${prefix}-url".path})"
        GRAFANA_SERVICE_ACCOUNT_TOKEN="$(cat ${lib.escapeShellArg config.sops.secrets."${prefix}-service-account-token".path})"
        export GRAFANA_URL GRAFANA_SERVICE_ACCOUNT_TOKEN
        exec uvx mcp-grafana
      '';
    })
  secretPrefixes;
  remotePackages = lib.mapAttrs (name: url:
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
    cloud = "http://litellm.internal.kentaro1043.com/grafana-cloud/mcp";
    trap-sakura = "http://litellm.internal.kentaro1043.com/grafana-trap/mcp";
  };
  packages = localPackages // remotePackages;
in {
  home.packages = lib.attrValues packages;

  sops.secrets =
    lib.listToAttrs (lib.concatMap (prefix: [
      (lib.nameValuePair "${prefix}-url" {})
      (lib.nameValuePair "${prefix}-service-account-token" {})
    ]) (lib.attrValues secretPrefixes))
    // {
      litellm-api-key = {};
    };

  programs.mcp.servers = lib.mapAttrs' (name: package:
    lib.nameValuePair "grafana-${name}" {
      command = lib.getExe package;
    })
  packages;
}
