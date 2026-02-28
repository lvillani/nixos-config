{ ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.user = ./home.nix;

  nixpkgs.config.allowUnfree = true;
}
