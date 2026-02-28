{ ... }:
{
  system.stateVersion = 6;

  determinateNix.enable = true;

  homebrew.enable = true;
  homebrew.brews = [ "mas" ];
  homebrew.onActivation.cleanup = "zap";

  networking.applicationFirewall.enable = true;
  networking.applicationFirewall.allowSigned = true;
  networking.applicationFirewall.allowSignedApp = false;

  security.pam.services.sudo_local.touchIdAuth = true;
}
