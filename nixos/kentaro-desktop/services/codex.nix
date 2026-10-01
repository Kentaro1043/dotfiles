{
  config,
  outputs,
  pkgs,
  ...
}: let
  homeDirectory = config.users.users.kentaro.home;
  codex = outputs.homeConfigurations."kentaro@kentaro-desktop".config.programs.codex.package;
in {
  systemd.services.codex-app-server = {
    description = "Codex App Server with Remote Control";
    wantedBy = ["multi-user.target"];
    wants = ["network-online.target"];
    after = ["network-online.target"];
    path = with pkgs; [
      bash
      gh
      git
      nix
      nodejs
      uv
    ];
    unitConfig.RequiresMountsFor = ["${homeDirectory}/.codex"];

    environment = {
      HOME = homeDirectory;
      CODEX_HOME = "${homeDirectory}/.codex";
    };

    serviceConfig = {
      Type = "simple";
      User = "kentaro";
      Group = "users";
      WorkingDirectory = homeDirectory;
      # Home ManagerのCLIとMCP認証ラッパーを共有する。
      ExecStart = "${codex}/bin/codex app-server --remote-control --listen unix://";
      Restart = "on-failure";
      RestartSec = "5s";
      UMask = "0077";
    };
  };
}
