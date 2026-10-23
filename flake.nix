{
  inputs = {
    # Nixpkgs inputs for stable and unstable channels
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # All other inputs sorted alphabetically
    agent-skills-nix.url = "github:Kyure-A/agent-skills-nix";
    agent-skills-nix.inputs.nixpkgs.follows = "nixpkgs";

    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Temporary source until https://github.com/nix-darwin/nix-darwin/pull/1744 is merged.
    nix-darwin-nh.url = "github:nix-darwin/nix-darwin/fed1d4c98d9f679c68a762966f0deada93b7c999";
    nix-darwin-nh.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;

      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [ (import ./overlays { inherit inputs; }) ];
    };
}
