{ ... }:
{
  system.stateVersion = "25.11";

  boot.initrd.systemd.enable = true;

  boot.kernel.sysctl."kernel.sysrq" = 1;
  boot.kernelParams = [ "quiet" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 0;

  boot.plymouth.enable = true;
}
