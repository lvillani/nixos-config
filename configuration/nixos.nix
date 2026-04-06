{ pkgs, ... }:
{
  boot.initrd.systemd.enable = true;

  boot.kernel.sysctl."kernel.sysrq" = 1;
  boot.kernelParams = [ "quiet" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 0;

  boot.plymouth.enable = true;

  documentation.man.generateCaches = false;

  networking.nftables.enable = true;

  networking.firewall.logRefusedPackets = true;
  networking.firewall.logReversePathDrops = true;

  programs.nix-ld.enable = true;

  users.users.user = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
  };
}
