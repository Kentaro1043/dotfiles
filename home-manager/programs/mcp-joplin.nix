{
  config,
  lib,
  pkgs,
  ...
}: let
  package = pkgs.writeShellApplication {
    name = "mcp-joplin";
    runtimeInputs = [pkgs.coreutils pkgs.nodejs];
    text = ''
      token="$(cat ${lib.escapeShellArg config.sops.secrets.joplin-api-token.path})"
      case "$token" in
        ""|*[!0-9a-fA-F]*) echo "Invalid Joplin API token" >&2; exit 1 ;;
      esac
      exec npx --yes mcp-remote@0.1.38 "http://127.0.0.1:41184/mcp?token=$token" --allow-http
    '';
  };
in {
  home.packages = [package];
  sops.secrets.joplin-api-token = {};
  programs.mcp.servers.joplin.command = lib.getExe package;
}
