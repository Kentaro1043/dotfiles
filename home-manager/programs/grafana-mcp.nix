{
  config,
  lib,
  pkgs,
  ...
}: let
  secretPrefixes = {
    work = "codex-grafana-work";
  };
  commands = lib.mapAttrs (name: prefix:
    lib.getExe (pkgs.writeShellApplication {
      name = "mcp-grafana-${name}";
      runtimeInputs = [pkgs.coreutils pkgs.uv];
      text = ''
        GRAFANA_URL="$(cat ${lib.escapeShellArg config.sops.secrets."${prefix}-url".path})"
        GRAFANA_SERVICE_ACCOUNT_TOKEN="$(cat ${lib.escapeShellArg config.sops.secrets."${prefix}-service-account-token".path})"
        export GRAFANA_URL GRAFANA_SERVICE_ACCOUNT_TOKEN
        exec uvx mcp-grafana
      '';
    }))
  secretPrefixes;
in {
  _module.args.grafanaMcpCommands = commands;

  sops.secrets =
    lib.listToAttrs (lib.concatMap (prefix: [
      (lib.nameValuePair "${prefix}-url" {})
      (lib.nameValuePair "${prefix}-service-account-token" {})
    ]) (lib.attrValues secretPrefixes))
    // {
      grafana-mcp-trap-authorization = {};
    };

  programs.mcp.servers =
    lib.mapAttrs' (name: command:
      lib.nameValuePair "grafana-${name}" {
        inherit command;
      })
    commands
    // {
      grafana-trap-sakura = {
        url = "https://s-grafana-mcp.trap.jp/mcp";
        headers.Authorization = "{file:${config.sops.secrets.grafana-mcp-trap-authorization.path}}";
      };
      grafana-trap-conoha = {
        url = "https://grafana-mcp.trap.jp/mcp";
        headers.Authorization = "{file:${config.sops.secrets.grafana-mcp-trap-authorization.path}}";
      };
      grafana-cloud = {
        url = "https://mcp.grafana.com/mcp";
        headers."X-Grafana-URL" = "https://kentaro1043.grafana.net";
      };
    };
}
