{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.self.modules.nixos-and-darwin.shared ];

  boot.initrd.systemd.enable = true;

  boot.kernel.sysctl."kernel.sysrq" = 1;
  boot.kernelParams = [ "quiet" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 0;

  boot.plymouth.enable = true;

  networking.nftables.enable = true;

  networking.firewall.filterForward = true;
  networking.firewall.logRefusedPackets = true;
  networking.firewall.logReversePathDrops = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  programs.nix-ld.enable = true;

  users.users.user = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
  };
}
