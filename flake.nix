{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Temporary source until https://github.com/nix-darwin/nix-darwin/pull/1744 is merged.
    nix-darwin-nh.url = "github:nix-darwin/nix-darwin/6bd5190096d6d64fb354cac3ba688fb1ad69a197";
    nix-darwin-nh.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;

      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [ (import ./overlays { inherit inputs; }) ];
    };
}
