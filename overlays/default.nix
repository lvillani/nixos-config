{ inputs }:
final: prev:
let
  system = prev.stdenv.hostPlatform.system;

  vscodeVersion = "1.141.0";
  vscodeSrc = {
    aarch64-darwin = {
      name = "VSCode_${vscodeVersion}_darwin-arm64.zip";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/darwin-arm64/stable";
      hash = "sha256-m0rjhuPPc417qZAjfd8KGAkskkobyuRl7UaXlkdF9C0=";
    };
    x86_64-linux = {
      name = "VSCode_${vscodeVersion}_linux-x64.tar.gz";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/linux-x64/stable";
      hash = "sha256-131YjwRUy6qnHnI0l95BYNFblfukmIq+F3sUMua9Vwo=";
    };
  };
in
{
  unstable = import inputs.nixpkgs-unstable {
    inherit (prev.stdenv.hostPlatform) system;
    inherit (prev) config;
  };

  pi-coding-agent = inputs.pi.packages.${prev.stdenv.hostPlatform.system}.default;

  vscode = final.unstable.vscode.overrideAttrs (previousAttrs: {
    version = vscodeVersion;
    src = final.unstable.fetchurl vscodeSrc.${system};
  });
}
