{ inputs }:
final: prev:
let
  system = prev.stdenv.hostPlatform.system;

  vscodeVersion = "1.127.0";
  vscodeSystem = {
    aarch64-darwin = "darwin-arm64";
    x86_64-linux = "linux-x64";
  };
  vscodeSrc = {
    aarch64-darwin = {
      name = "VSCode_${vscodeVersion}_darwin-arm64.zip";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/darwin-arm64/stable";
      hash = "sha256-IHu9EwW9/oS2FTr/mB7ugMss5Pku3IyslqFYr4riZyk=";
    };
    x86_64-linux = {
      name = "VSCode_${vscodeVersion}_linux-x64.tar.gz";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/linux-x64/stable";
      hash = "sha256-4G+zZ5HJuvdJXUt9wPWqqCVOfRpgpe5D5sfevAXJYrU=";
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
    buildInputs =
      (previousAttrs.buildInputs or [ ])
      ++ prev.lib.optionals prev.stdenv.hostPlatform.isLinux [
        prev.libei
        prev.libjpeg8
        prev.libxtst
        prev.pipewire
      ];
    postPatch =
      builtins.replaceStrings
        [ "@vscode/ripgrep/bin/rg" ]
        [ "@vscode/ripgrep-universal/bin/${vscodeSystem.${system}}/rg" ]
        previousAttrs.postPatch;
  });
}
