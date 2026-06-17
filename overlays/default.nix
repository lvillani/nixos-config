{ inputs }:
final: prev:
let
  system = prev.stdenv.hostPlatform.system;

  vscodeVersion = "1.125.0";
  vscodeSystem = {
    aarch64-darwin = "darwin-arm64";
    x86_64-linux = "linux-x64";
  };
  vscodeSrc = {
    aarch64-darwin = {
      name = "VSCode_${vscodeVersion}_darwin-arm64.zip";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/darwin-arm64/stable";
      hash = "sha256-dMSYvcryDd8Wqu8GHwnrp5pyRJwLzpV9BDLnpyWcxG0=";
    };
    x86_64-linux = {
      name = "VSCode_${vscodeVersion}_linux-x64.tar.gz";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/linux-x64/stable";
      hash = "sha256-TTulHpCiT2eay2tb7e1ub164rgttBnB36Cc4JVoxf08=";
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
