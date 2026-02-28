{ pkgs, ... }:
let
  homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then /Users/user else /home/user;
  vscodeUserDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "Library/Application Support/Code/User"
    else
      ".config/Code/User";
in
{
  home.stateVersion = "25.11";

  home.homeDirectory = homeDirectory;
  home.username = "user";

  home.file = {
    "${vscodeUserDirectory}/snippets" = {
      source = ./files/vscode/snippets;
      recursive = true;
    };
  };

  programs.home-manager.enable = true;

  programs.fish.enable = true;
  programs.fish.functions = {
    fish_prompt = builtins.readFile ./files/fish/fish_prompt.fish;
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

    p1 = "ping 1.1.1.1";
    p8 = "ping 8.8.8.8";
  };
  programs.fish.shellInit = ''
    set fish_greeting
  '';

  programs.vscode.enable = true;
  programs.vscode.profiles.default.enableExtensionUpdateCheck = false;
  programs.vscode.profiles.default.enableUpdateCheck = false;
}
