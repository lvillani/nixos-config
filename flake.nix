{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    determinate.inputs.nixpkgs.follows = "nixpkgs";

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
          ./configuration-common.nix
          ./configuration.nix
          inputs.determinate.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
        ];
      };

      darwinConfigurations.main = inputs.nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration-common.nix
          ./configuration-darwin.nix
          inputs.determinate.darwinModules.default
          inputs.home-manager.darwinModules.home-manager
        ];
      };

      homeConfigurations.user = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${builtins.currentSystem};
        modules = [ ./home.nix ];
      };
    };
}
