{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # general
    git
    keychain
    typst
    oci-cli

    # fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif

    # shell
    powerline-fonts
    zsh-abbr
    zsh-you-should-use
    zsh-nix-shell

    # node version management
    volta
    # node linter
    biome

    # Scala
    scala
    scalafmt

    # yaml linter
    yamllint

    # Kubernetes related packages
    kubectl
    kustomize
    sops
    age
    kustomize-sops
    kubeconform

    # Python
    uv
  ];

  # Enable font
  fonts.fontconfig.enable = true;
}
