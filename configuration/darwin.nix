{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    appcleaner
    coconutbattery
  ];

  homebrew.enable = true;
  homebrew.brews = [ "mas" ];
  homebrew.onActivation.cleanup = "zap";

  networking.applicationFirewall.enable = true;
  networking.applicationFirewall.allowSigned = true;
  networking.applicationFirewall.allowSignedApp = false;

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.autohide-delay = 0.0;
  system.defaults.dock.mru-spaces = false;

  system.primaryUser = "user";
}
