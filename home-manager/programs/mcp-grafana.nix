{
  config,
  lib,
  pkgs,
  ...
}: let
  secretPrefixes = {
    work = "grafana-mcp-work";
  };
  workPackages = lib.mapAttrs (name: prefix:
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
      text =
        if name == "cloud"
        then ''
          exec npx --yes mcp-remote@0.1.38 ${lib.escapeShellArg url} \
            --header 'X-Grafana-URL:https://kentaro1043.grafana.net'
        ''
        else ''
          GRAFANA_MCP_AUTHORIZATION="$(cat ${lib.escapeShellArg config.sops.secrets.grafana-mcp-trap-authorization.path})"
          export GRAFANA_MCP_AUTHORIZATION
          # mcp-remote側で環境変数を展開する。
          # shellcheck disable=SC2016
          exec npx --yes mcp-remote@0.1.38 ${lib.escapeShellArg url} \
            --header 'Authorization:''${GRAFANA_MCP_AUTHORIZATION}'
        '';
    }) {
    cloud = "https://mcp.grafana.com/mcp";
    trap-sakura = "https://s-grafana-mcp.trap.jp/mcp";
    trap-conoha = "https://grafana-mcp.trap.jp/mcp";
  };
  packages = workPackages // remotePackages;
in {
  home.packages = lib.attrValues packages;

  sops.secrets =
    lib.listToAttrs (lib.concatMap (prefix: [
      (lib.nameValuePair "${prefix}-url" {})
      (lib.nameValuePair "${prefix}-service-account-token" {})
    ]) (lib.attrValues secretPrefixes))
    // {
      grafana-mcp-trap-authorization = {};
    };

  programs.mcp.servers = lib.mapAttrs' (name: package:
    lib.nameValuePair "grafana-${name}" {
      command = lib.getExe package;
    })
  packages;
}
