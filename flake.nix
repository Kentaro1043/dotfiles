{
  description = "Kentaro1043's home-manager configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS-WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nix-darwin,
    nixos-wsl,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    forAllSystems-unstable = nixpkgs-unstable.lib.genAttrs systems;
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
          ./home-manager/home.nix
        ];
      };

      "kentaro@kentaro-mac" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {
          inherit
            inputs
            outputs
            ;
        };
        modules = [
          ./home-manager/home.nix
        ];
      };
    };

    darwinConfigurations."kentaro@kentaro-mac" = nix-darwin.lib.darwinSystem {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [
        ./nix-darwin
      ];
    };

    nixosConfigurations = {
      "kentaro@kentaro-win" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/configuration.nix
        ];
      };
    };
  };
}
