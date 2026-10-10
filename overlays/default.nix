{ inputs }:
final: prev:
{
  unstable = import inputs.nixpkgs-unstable {
    inherit (prev.stdenv.hostPlatform) system;
    inherit (prev) config;
  };

  pi-coding-agent = inputs.pi.packages.${prev.stdenv.hostPlatform.system}.default;

  vscode = final.unstable.vscode;
}
