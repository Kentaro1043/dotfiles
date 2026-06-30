{
  lib,
  pkgs,
  ...
}: {
  programs.vscodium = {
    enable = true;
    package =
      # https://github.com/continuedev/continue/issues/821#issuecomment-3227673526
      pkgs.unstable.vscodium.overrideAttrs (
        final: prev: {
          preFixup =
            prev.preFixup
            + "gappsWrapperArgs+=( --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [pkgs.gcc.cc.lib]} )";
        }
      );
    # Don't work
    #argvSettings = {
    #  "locale" = "ja";
    #};
    argvSettings = builtins.fromJSON (builtins.readFile ./vscode-argv.json);
    profiles.default = {
      userSettings = builtins.fromJSON (builtins.readFile ./vscode-settings.json);
      keybindings = builtins.fromJSON (builtins.readFile ./vscode-keybindings.json);
      extensions = with pkgs.nix-vscode-extensions.open-vsx-release;
        [
          # Editor
          dracula-theme.theme-dracula
          pkief.material-icon-theme
          eamodio.gitlens
          vivaxy.vscode-conventional-commits
          jetify.devbox
          esbenp.prettier-vscode

          # AI
          continue.continue
          saoudrizwan.claude-dev # Cline
          google.gemini-cli-vscode-ide-companion
          qwenlm.qwen-code-vscode-ide-companion
          sst-dev.opencode
          anthropic.claude-code # Unfree
          # openai.chatgpt # Unfree

          # Platform
          ms-kubernetes-tools.vscode-kubernetes-tools

          # Languages
          # Nix
          jnoortheen.nix-ide
          # C/C++
          llvm-vs-code-extensions.vscode-clangd
          llvm-vs-code-extensions.lldb-dap
          vadimcn.vscode-lldb
          # yaml
          redhat.vscode-yaml
          redhat.ansible
          # Typst
          myriad-dreamin.tinymist
          # Go
          golang.go
          # Python
          ms-python.python
          ms-python.debugpy
          ms-python.vscode-python-envs
          astral-sh.ty
          charliermarsh.ruff
          # Jupyter
          ms-toolsai.jupyter
          ms-toolsai.jupyter-keymap
          google.colab
          # Astro
          astro-build.astro-vscode
          # toml
          tamasfe.even-better-toml
          # JS/TS
          biomejs.biome
          # Vue.js
          vue.volar
          # Java
          vscjava.vscode-java-debug
          vscjava.vscode-java-test
          vscjava.vscode-maven
          vscjava.vscode-gradle
          vscjava.vscode-java-dependency
          redhat.java
          # Docker
          docker.docker
          exiasr.hadolint
          # Terraform
          opentofu.vscode-opentofu
          # GitHub Actions
          github.vscode-github-actions
          # Markdown
          davidanson.vscode-markdownlint
          marp-team.marp-vscode
        ]
        ++ [
          pkgs.nix-vscode-extensions.vscode-marketplace-release."3w36zj6".textlint
          pkgs.nix-vscode-extensions.vscode-marketplace-release.openai.chatgpt
        ];
      enableExtensionUpdateCheck = false;
      enableMcpIntegration = true;
    };
  };
}
