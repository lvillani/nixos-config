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

    docker-here = "docker run --rm -it -v (pwd):(pwd) -w (pwd)";
    docker-here2 = "docker run --rm -it -v (pwd):(pwd) -w (pwd) -u (id -u):(id -g)";
  };
  programs.fish.shellInit = ''
    set fish_greeting

    if test -x /opt/homebrew/bin/brew
      eval (/opt/homebrew/bin/brew shellenv)
    end
  '';

  programs.vscode.enable = true;
  programs.vscode.profiles.default.enableExtensionUpdateCheck = false;
  programs.vscode.profiles.default.enableUpdateCheck = false;
}
