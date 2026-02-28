{ pkgs, ... }:
let
  homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then /Users/user else /home/user;
in
{
  home.stateVersion = "25.11";

  home.homeDirectory = homeDirectory;
  home.username = "user";

  programs.home-manager.enable = true;

  programs.fish.enable = true;
  programs.fish.functions = {
    fish_prompt = builtins.readFile ./files/fish_prompt.fish;
  };
  programs.fish.plugins = [
    {
      name = "done";
      src = pkgs.fishPlugins.done.src;
    }
  ];
  programs.fish.shellAbbrs = {
    g = "git";
    r = "exec fish";
  };
  programs.fish.shellInit = ''
    set fish_greeting
  '';

  programs.vscode.enable = true;
  programs.vscode.profiles.default.enableExtensionUpdateCheck = false;
  programs.vscode.profiles.default.enableUpdateCheck = false;
}
