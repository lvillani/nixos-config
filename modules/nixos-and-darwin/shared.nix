{ inputs, pkgs, ... }:
{
  imports = [ inputs.self.modules.common.nix-registry ];

  environment.systemPackages = with pkgs; [
    htop
  ];

  nix.channel.enable = false;
  nix.settings.keep-outputs = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Europe/Rome";

  programs.fish.enable = true;

  programs.nh.enable = true;
  programs.nh.clean.enable = true;
  programs.nh.clean.extraArgs = "--optimise";
}
