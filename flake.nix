{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    { self, ... }@inputs:
    let
      nixosModules = [
        ./configuration/common.nix
        ./configuration/nixos.nix
        inputs.home-manager.nixosModules.home-manager
      ];

      nixosModulesGnome = nixosModules ++ [ ./configuration/nixos-gnome.nix ];
    in
    {
      #
      # NixOS
      #

      nixosConfigurations.base = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = nixosModules;
      };

      nixosConfigurations.base-gnome = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = nixosModulesGnome;
      };

      nixosConfigurations.base-gnome-framework = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = nixosModulesGnome ++ [ inputs.nixos-hardware.nixosModules.framework-13-7040-amd ];
      };

      #
      # nix-darwin
      #

      darwinConfigurations.base = inputs.nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration/common.nix
          ./configuration/darwin.nix
          inputs.home-manager.darwinModules.home-manager
        ];
      };

      #
      # Home Manager (standalone)
      #

      packages.x86_64-linux.homeConfigurations.base = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home.nix ];
      };

      packages.aarch64-darwin.homeConfigurations.base = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home.nix ];
      };

      #
      # Re-exported packages
      #

      # darwin-rebuild
      packages.aarch64-darwin.darwin-rebuild = inputs.nix-darwin.packages.aarch64-darwin.darwin-rebuild;

      # nixos-rebuild
      packages.aarch64-darwin.nixos-rebuild =
        inputs.nixpkgs.legacyPackages.aarch64-darwin.nixos-rebuild-ng;

      packages.x86_64-linux.nixos-rebuild = inputs.nixpkgs.legacyPackages.x86_64-linux.nixos-rebuild-ng;

      # home-manager
      packages.aarch64-darwin.home-manager = inputs.home-manager.packages.aarch64-darwin.default;
      packages.x86_64-linux.home-manager = inputs.home-manager.packages.x86_64-linux.default;
    };
}
