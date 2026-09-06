{ inputs }:
final: prev:
{
  unstable = import inputs.nixpkgs-unstable {
    inherit (prev.stdenv.hostPlatform) system;
    inherit (prev) config;
  };

  pi-coding-agent = final.unstable.pi-coding-agent;

  vscode = final.unstable.vscode;
}
