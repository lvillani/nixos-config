{ inputs }:
final: prev:
let
  system = prev.stdenv.hostPlatform.system;

  vscodeVersion = "1.131.0";
  vscodeSrc = {
    aarch64-darwin = {
      name = "VSCode_${vscodeVersion}_darwin-arm64.zip";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/darwin-arm64/stable";
      hash = "sha256-eWw64c0o1Fs/uEUMD4Zhzy9DYy46Dzj1Al8MSWdbz5k=";
    };
    x86_64-linux = {
      name = "VSCode_${vscodeVersion}_linux-x64.tar.gz";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/linux-x64/stable";
      hash = "sha256-hjLm+a7XosVhJHVVn/PRjGYdNUMsImUG23BESpmEVzE=";
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

  pi-coding-agent = final.unstable.pi-coding-agent;

  omp-bin = import ../packages/omp-bin.nix {
    pkgs = final;
    system = system;
  };
}
