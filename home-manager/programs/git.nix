{...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        email = "71170923+Kentaro1043@users.noreply.github.com";
        name = "Kentaro1043";
      };
      pull.rebase = false;
      init.defaultBranch = "main";
      ghq.root = "~/source/repos";
    };
  };
}
