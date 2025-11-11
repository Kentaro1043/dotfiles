{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  programs.starship = {
    enable = true;

    # 何故か機能しない
    #presets = [
    #  "bracketed-segments"
    #];

    # Downloaded preset from https://starship.rs/ja-JP/presets/bracketed-segments
    settings =
      builtins.fromTOML (builtins.readFile ./bracketed-segments.toml)
      // {
        command_timeout = 1000;

        sudo.disabled = false;

        scala = {
          detect_folders = [];
        };

        kubernetes = {
          disabled = false;
          # detect_files = [
          #   "kustomization.yaml"
          # ];
        };

        time = {
          disabled = false;
          format = "[\\[🕙 $time\\]]($style) ";
          time_format = "%R";
        };

        gcloud = {
          disabled = false;
        };

        # Dracula
        # https://draculatheme.com/starship
        aws.style = "bold #ffb86c";
        cmd_duration.style = "bold #f1fa8c";
        directory.style = "bold #50fa7b";
        hostname.style = "bold #ff5555";
        git_branch.style = "bold #ff79c6";
        git_status.style = "bold #ff5555";
        username = {
          format = "[$user]($style) on ";
          style_user = "bold #bd93f9";
        };
        character = {
          success_symbol = "[λ](bold #f8f8f2)";
          error_symbol = "[λ](bold #ff5555)";
        };
      };
  };
}
