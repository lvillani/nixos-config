{ inputs }:
final: prev:
let
  system = prev.stdenv.hostPlatform.system;

  vscodeVersion = "1.145.2";
  vscodeSrc = {
    aarch64-darwin = {
      name = "VSCode_${vscodeVersion}_darwin-arm64.zip";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/darwin-arm64/stable";
      hash = "sha256-UYOHVWztTjrYmNBi/vKV+4o2O36E2ZmqdIYuuP5ziiE=";
    };
    x86_64-linux = {
      name = "VSCode_${vscodeVersion}_linux-x64.tar.gz";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/linux-x64/stable";
      hash = "sha256-OwEoZjn6Am/YYJRLgR1Bj3uTvF3ER9nmB7DNE3fPuqI=";
    };
  };
in
{
  unstable = import inputs.nixpkgs-unstable {
    inherit system;
    inherit (prev) config;
  };

  pi-coding-agent = final.unstable.pi-coding-agent;

  vscode = final.unstable.vscode.overrideAttrs (_: {
    version = vscodeVersion;
    src = final.unstable.fetchurl vscodeSrc.${system};
  });
}
