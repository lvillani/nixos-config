{ inputs }:
final: prev:
let
  system = prev.stdenv.hostPlatform.system;

  vscodeVersion = "1.124.0";
  vscodeSystem = {
    aarch64-darwin = "darwin-arm64";
    x86_64-linux = "linux-x64";
  };
  vscodeSrc = {
    aarch64-darwin = {
      name = "VSCode_${vscodeVersion}_darwin-arm64.zip";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/darwin-arm64/stable";
      hash = "sha256-9AC7xsB7Wj4WTN7Z0i3H/W/DP54ttPc0wGPNrBFGXrk=";
    };
    x86_64-linux = {
      name = "VSCode_${vscodeVersion}_linux-x64.tar.gz";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/linux-x64/stable";
      hash = "sha256-eUiOpSJCcdDeSk3NRv4fxN3RSrG4axGB6U5zh5DEZXc=";
    };
  };
in
{
  unstable = import inputs.nixpkgs-unstable {
    inherit (prev.stdenv.hostPlatform) system;
    inherit (prev) config;
  };

  vscode = prev.vscode.overrideAttrs (previousAttrs: {
    version = vscodeVersion;
    src = prev.fetchurl vscodeSrc.${system};
    postPatch =
      builtins.replaceStrings
        [ "@vscode/ripgrep/bin/rg" ]
        [ "@vscode/ripgrep-universal/bin/${vscodeSystem.${system}}/rg" ]
        previousAttrs.postPatch;
  });
}
