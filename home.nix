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
    ".config/fish" = {
      source = ./files/fish;
      recursive = true;
    };
    "${vscodeUserDirectory}/snippets" = {
      source = ./files/vscode/snippets;
      recursive = true;
    };
  };

  programs.home-manager.enable = true;

  programs.fish.enable = true;
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

    if test "$TERM_PROGRAM" = "vscode"
      set -x EDITOR code --wait
    else
      set -x EDITOR vim
    end
  '';

  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false; # Will print a warning unless set to false, since this option is being deprecated.
  programs.ssh.includes = [ "config.d" ];
  programs.ssh.matchBlocks = {
    "*" = {
      serverAliveCountMax = 1;
      serverAliveInterval = 30;
    };
  };

  programs.vim.enable = true;
  programs.vim.extraConfig = ''
    filetype plugin indent on
    set autoindent
    set backspace=indent,eol,start
    set expandtab
    set hlsearch
    set incsearch
    set linebreak
    set nocompatible
    set number relativenumber
    set ruler
    set shiftwidth=4
    set showcmd
    set tabstop=4
    syntax on
  '';

  programs.vscode.enable = true;
  programs.vscode.profiles.default.enableExtensionUpdateCheck = false;
  programs.vscode.profiles.default.enableUpdateCheck = false;
}
