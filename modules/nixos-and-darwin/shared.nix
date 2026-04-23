{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    htop
  ];

  nix.channel.enable = false;
  nix.gc.automatic = true;
  nix.optimise.automatic = true;
  nix.settings.keep-outputs = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Europe/Rome";

  programs.fish.enable = true;
}
