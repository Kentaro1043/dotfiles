{
  description = "Kentaro1043's home-manager configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-2505.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # for uhd
    nixpkgs-fix-uhd.url = "github:nixos/nixpkgs/4199f186ecc15a2a56db94152f855606728aeace";

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
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-2505,
    nixpkgs-unstable,
    nixpkgs-fix-uhd,
    home-manager,
    nix-darwin,
    nixos-wsl,
    determinate,
    sops-nix,
    nixvim,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    forAllSystems-2505 = nixpkgs-2505.lib.genAttrs systems;
    forAllSystems-unstable = nixpkgs-unstable.lib.genAttrs systems;
    forAllSystems-fix-uhd = nixpkgs-fix-uhd.lib.genAttrs systems;
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

      "kentaro@kentaro-mac" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {
          inherit inputs outputs;
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
    };
  };
}
