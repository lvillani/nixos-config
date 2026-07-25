{ inputs }:
final: prev:
let
  system = prev.stdenv.hostPlatform.system;

  vscodeVersion = "1.130.0";
  vscodeSrc = {
    aarch64-darwin = {
      name = "VSCode_${vscodeVersion}_darwin-arm64.zip";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/darwin-arm64/stable";
      hash = "sha256-bhbMscqsOU2ux4i2XShdMKgJPN8tuWVSxTzJ0CUvJNM=";
    };
    x86_64-linux = {
      name = "VSCode_${vscodeVersion}_linux-x64.tar.gz";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/linux-x64/stable";
      hash = "sha256-fWrT06eKxFUcFGMfeNfgPIUoKrUFw86LG8BOAfr+iOo=";
    };
  };
in
{
  unstable = import inputs.nixpkgs-unstable {
    inherit (prev.stdenv.hostPlatform) system;
    inherit (prev) config;
  };

  vscode = final.unstable.vscode.overrideAttrs (previousAttrs: {
    version = vscodeVersion;
    src = final.unstable.fetchurl vscodeSrc.${system};
  });
}
