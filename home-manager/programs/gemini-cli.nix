{
  pkgs,
  lib,
  ...
}: {
  programs.gemini-cli = {
    enable = true;
    package = pkgs.llm-agents.gemini-cli;
  };

  home.activation.setupGeminiSetting = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $HOME/.gemini
    $DRY_RUN_CMD rm -f $HOME/.gemini/settings.json $HOME/.gemini/sandbox.Dockerfile
    $DRY_RUN_CMD cp ${./gemini-cli-settings.json} $HOME/.gemini/settings.json
    $DRY_RUN_CMD cp ${./gemini-cli.Dockerfile} $HOME/.gemini/sandbox.Dockerfile
    $DRY_RUN_CMD chmod 644 $HOME/.gemini/settings.json
    if ${pkgs.docker}/bin/docker info >/dev/null 2>&1; then
      $DRY_RUN_CMD ${pkgs.docker}/bin/docker build \
        --file "$HOME/.gemini/sandbox.Dockerfile" \
        --build-arg CLI_VERSION_ARG=0.40.0 \
        -t gemini-my-sandbox:latest \
        $HOME/.gemini
    else
      $DRY_RUN_CMD echo "Docker daemon is not running."
    fi
  '';
}
