{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, ... }@inputs:
    {
      nixosConfigurations.main = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration/common.nix
          ./configuration/nixos.nix
          inputs.home-manager.nixosModules.home-manager
        ];
      };

      darwinConfigurations.main = inputs.nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration/common.nix
          ./configuration/darwin.nix
          inputs.home-manager.darwinModules.home-manager
        ];
      };

      packages.x86_64-linux.homeConfigurations.user = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home.nix ];
      };

      packages.aarch64-darwin.homeConfigurations.user = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
        modules = [ ./home.nix ];
      };

      # nixos-rebuild
      packages.aarch64-darwin.nixos-rebuild =
        inputs.nixpkgs.legacyPackages.aarch64-darwin.nixos-rebuild-ng;

      packages.x86_64-linux.nixos-rebuild = inputs.nixpkgs.legacyPackages.x86_64-linux.nixos-rebuild-ng;

      # home-manager
      packages.aarch64-darwin.home-manager = inputs.home-manager.packages.aarch64-darwin.default;
      packages.x86_64-linux.home-manager = inputs.home-manager.packages.x86_64-linux.default;
    };
}
