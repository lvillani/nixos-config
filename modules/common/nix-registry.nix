{ inputs, ... }:
{
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;

  nix.registry.n.to = {
    type = "indirect";
    id = "nixpkgs";
  };
  nix.registry.nu.to = {
    type = "indirect";
    id = "nixpkgs-unstable";
  };
}
