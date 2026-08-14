{ inputs }:
final: prev:
{
  unstable = import inputs.nixpkgs-unstable {
    inherit (prev.stdenv.hostPlatform) system;
    inherit (prev) config;
  };

  vscode = final.unstable.vscode;

  pi-coding-agent = final.unstable.pi-coding-agent;
}
