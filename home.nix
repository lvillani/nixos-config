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
    "${vscodeUserDirectory}/prompts" = {
      source = ./files/vscode/prompts;
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

  programs.git.enable = true;
  programs.git.ignores = [
    ".cache"
    ".DS_Store"
    ".idea"
    ".venv"
    ".vscode"
  ];
  programs.git.settings = {
    advice.detachedHead = false;
    alias.b = "branch";
    alias.c = "commit";
    alias.caanr = "commit --all --amend --no-edit --reset-author";
    alias.canr = "commit --amend --no-edit --reset-author";
    alias.cl = "clean -dffx -e .idea -e .vscode -e .venv -e venv";
    alias.co = "checkout";
    alias.cob = "checkout -b";
    alias.cp = "cherry-pick";
    alias.cpa = "cherry-pick --abort";
    alias.cpc = "cherry-pick --continue";
    alias.d = "diff";
    alias.fp = "fetch --prune";
    alias.fppt = "fetch --prune --prune-tags";
    alias.gcap = "gc --aggressive --prune";
    alias.l = "log --graph --oneline";
    alias.p = "push";
    alias.pf = "push --force-with-lease";
    alias.poh = "push --set-upstream origin HEAD";
    alias.pt = "push --tags";
    alias.pu = "pull --autostash --rebase";
    alias.r = "rebase";
    alias.ra = "rebase --abort";
    alias.rc = "rebase --continue";
    alias.ri = "rebase --interactive";
    alias.s = "status --short";
    alias.t = "tag";
    alias.td = "tag --delete";
    alias.tl = "tag --list";
    alias.wip = "commit -am \"wip [skip ci]\" --no-verify";
    alias.wip2 = "commit -am \"wip\" --no-verify";
    commit.verbose = true;
    diff.algorithm = "histogram";
    diff.colorMoved = "plain";
    diff.mnemonicPrefix = true;
    diff.renames = true;
    fetch.all = false;
    fetch.prune = true;
    fetch.pruneTags = true;
    pull.rebase = true;
    push.autoSetupRemote = true;
    push.default = "simple";
    rebase.autoSquash = true;
    rebase.autoStash = true;
    rebase.updateRefs = true;
    rerere.autoupdate = true;
    rerere.enabled = true;
    submodule.recurse = true;
    tag.sort = "version:refname";
    user.email = "lorenzo@villani.me";
    user.name = "Lorenzo Villani";
    user.useConfigOnly = true;
  };

  programs.go.enable = true;
  programs.go.telemetry.mode = "off";

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
  programs.vscode.profiles.default.extensions =
    with pkgs.vscode-extensions;
    [
      github.copilot
      github.copilot-chat
      golang.go
      jnoortheen.nix-ide
      redhat.vscode-yaml
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "rewrap-revived";
        publisher = "dnut";
        version = "1.16.3";
        sha256 = "sha256-KgvAN/zsGf0SKnOeKAfzl6TUqfU5WJ6OeKZjSGSGSvE=";
      }
    ];
  programs.vscode.profiles.default.userSettings = {
    "[nix]" = {
      "editor.formatOnSave" = true;
    };
    "[yaml]" = {
      "editor.defaultFormatter" = "redhat.vscode-yaml";
    };
    "editor.inlineSuggest.minShowDelay" = 1000;
    "files.autoSave" = "onFocusChange";
    "github.copilot.nextEditSuggestions.enabled" = true;
    "telemetry.telemetryLevel" = "off";
    "yaml.customTags" = [ "!reference sequence" ]; # GitLab CI !reference tag
  };
}
