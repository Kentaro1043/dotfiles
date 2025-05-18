{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      # general
      git
      gnumake
      keychain
      typst
      oci-cli
      gh

      # fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # shell
      powerline-fonts
      zsh-abbr
      zsh-you-should-use
      zsh-nix-shell
      nix-zsh-completions

      # tex
      tex-fmt

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
      k3d

      # Python
      uv
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      # Docker
      # Disable on Linux because I use Docker Desktop on Windows
      docker
      colima
    ];

  # Enable font
  fonts.fontconfig.enable = true;
}
