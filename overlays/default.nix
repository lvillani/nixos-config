{ inputs }:
final: prev:
let
  system = prev.stdenv.hostPlatform.system;

  vscodeVersion = "1.133.0";
  vscodeSrc = {
    aarch64-darwin = {
      name = "VSCode_${vscodeVersion}_darwin-arm64.zip";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/darwin-arm64/stable";
      hash = "sha256-KxP/IfZArzsb6c8sJn/V8BdfZwBOxuEmNTVgDzgr9C0=";
    };
    x86_64-linux = {
      name = "VSCode_${vscodeVersion}_linux-x64.tar.gz";
      url = "https://update.code.visualstudio.com/${vscodeVersion}/linux-x64/stable";
      hash = "sha256-K/GpDS8AivAJ6zxKe9CEm5JHoFiM05pASgseaRvmgWE=";
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
