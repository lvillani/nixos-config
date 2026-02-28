{ ... }:
{
  home.stateVersion = "25.11";

  home.homeDirectory = if builtins.currentSystem == "aarch64-darwin" then "/Users/user" else "/home/user";
  home.username = "user";

  programs.home-manager.enable = true;
}
