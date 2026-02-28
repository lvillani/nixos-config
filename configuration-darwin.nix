{ ... }:
{
  system.stateVersion = 6;

  determinateNix.enable = true;

  homebrew.enable = true;
  homebrew.brews = [ "mas" ];
  homebrew.onActivation.cleanup = "zap";
}
