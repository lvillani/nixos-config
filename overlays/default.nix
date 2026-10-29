{ inputs }:
final: prev:
let
  system = prev.stdenv.hostPlatform.system;

  vscodeVersion = "1.144.0";
  vscodeSrc = {
    aarch64-darwin = {
      name = "VSCode_${vscodeVersion}_darwin-arm64.zip";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/darwin-arm64/stable";
      hash = "sha256-zyoh28sjxCE7kSQ+PN03GX6RafkFZSWHET8WMp/JK4c=";
    };
    x86_64-linux = {
      name = "VSCode_${vscodeVersion}_linux-x64.tar.gz";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/linux-x64/stable";
      hash = "sha256-F7cqfm9ApbXc6YUPEO6hPOc0pjBStn+gIcwB5xWtTPE=";
    };
  };
in
{
  unstable = import inputs.nixpkgs-unstable {
    inherit (prev.stdenv.hostPlatform) system;
    inherit (prev) config;
  };

  pi-coding-agent = final.unstable.pi-coding-agent;

  vscode = final.unstable.vscode.overrideAttrs (previousAttrs: {
    version = vscodeVersion;
    src = final.unstable.fetchurl vscodeSrc.${system};
  });
}
