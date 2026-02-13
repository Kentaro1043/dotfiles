{
  description = "Kentaro1043's home-manager configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # for uhd
    nixpkgs-fix-uhd.url = "github:nixos/nixpkgs/4199f186ecc15a2a56db94152f855606728aeace";
    # for dump1090-fa
    nixpkgs-fix-dump1090.url = "github:nixos/nixpkgs/9318efde7bb08b14d3e45f0ddc9fe4df8f936ad5";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS-WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # Determine Nix
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    # sops-nix
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # nixvim
    nixvim.url = "github:nix-community/nixvim/nixos-25.11";

    # nix-vscode-extensions
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    nixos-wsl,
    determinate,
    sops-nix,
    nixvim,
    nix-vscode-extensions,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};

    homeConfigurations = {
      "kentaro@kentaro-win" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
        modules = [
          nixvim.homeModules.nixvim
          ./home-manager/home.nix
        ];
      };

      "kentaro@kentaro-desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs nix-vscode-extensions;
        };
        modules = [
          nixvim.homeModules.nixvim
          ./home-manager/home.nix
        ];
      };

      "kentaro@kentaro-mac" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {
          inherit inputs outputs nix-vscode-extensions;
        };
        modules = [
          nixvim.homeModules.nixvim
          ./home-manager/home.nix
        ];
      };
    };

    darwinConfigurations."kentaro@kentaro-mac" = nix-darwin.lib.darwinSystem {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [
        determinate.darwinModules.default
        ./nix-darwin
      ];
    };

    nixosConfigurations = {
      "kentaro@kentaro-win" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/kentaro-win/configuration.nix
          determinate.nixosModules.default
          sops-nix.nixosModules.sops
        ];
      };
      "kentaro@kentaro-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/kentaro-desktop/configuration.nix
        ];
      };
    };
  };
}
