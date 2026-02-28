{ pkgs, ... }:
let
  homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then /Users/user else /home/user;
in
{
  home.stateVersion = "25.11";

  home.homeDirectory = homeDirectory;
  home.username = "user";

  programs.home-manager.enable = true;
}
