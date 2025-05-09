{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    hello

    # general
    git
    keychain
    
    # shell
    powerline-fonts

    # node version management
    volta
    # node linter
    biome

    # yaml linter
    yamllint

    # Kubernetes related packages
    kubectl
    kustomize
    helm
    sops
    age
    kustomize-sops
    kubeconform

    # Python
    uv
  ];
}
