{ inputs }:
final: prev:
let
  system = prev.stdenv.hostPlatform.system;
  isDarwinAarch64 = system == "aarch64-darwin";
  isLinuxX86_64 = system == "x86_64-linux";
in
{
  unstable = import inputs.nixpkgs-unstable {
    inherit (prev.stdenv.hostPlatform) system;
    inherit (prev) config;
  };
}
// prev.lib.optionalAttrs isDarwinAarch64 {
  _1password-gui = prev._1password-gui.overrideAttrs (_: {
    src = prev.fetchurl {
      url = "https://downloads.1password.com/mac/1Password-8.12.21-aarch64.zip";
      hash = "sha256-WrWbGzBK65tVNl9Dc3OnJURiPpfbNLOYUJcVT0ETaAs=";
    };
  });
}
// prev.lib.optionalAttrs (isDarwinAarch64 || isLinuxX86_64) {
  # 1.123.0 is not yet in nixpkgs. Since 1.122, VSCode switched from
  # @vscode/ripgrep to @vscode/ripgrep-universal; patch postPatch accordingly.
  # TODO: rebase on nixpkgs-unstable's vscode recipe once 1.222+ lands on nixos-unstable.
  vscode = prev.vscode.overrideAttrs (
    old:
    let
      version = "1.123.0";
      plat =
        {
          x86_64-linux = "linux-x64";
          aarch64-darwin = "darwin-arm64";
        }
        .${system};
      archive_fmt = if prev.stdenv.hostPlatform.isDarwin then "zip" else "tar.gz";
      hash =
        {
          x86_64-linux = "sha256-L975R3F779LgaFTL4B6ZtImPd1LyXhImnDgCPmO5PI8=";
          aarch64-darwin = "sha256-AY6WeDzGEH5zXRosN1H/osxC3e5j0Hs9s2Ys2xe1UxI=";
        }
        .${system};
      oldRipgrepPath =
        {
          x86_64-linux = "resources/app/node_modules/@vscode/ripgrep/bin/rg";
          aarch64-darwin = "Contents/Resources/app/node_modules/@vscode/ripgrep/bin/rg";
        }
        .${system};
      newRipgrepPath =
        {
          x86_64-linux = "resources/app/node_modules/@vscode/ripgrep-universal/bin/linux-x64/rg";
          aarch64-darwin = "Contents/Resources/app/node_modules/@vscode/ripgrep-universal/bin/darwin-arm64/rg";
        }
        .${system};
    in
    {
      inherit version;
      src = prev.fetchurl {
        name = "VSCode_${version}_${plat}.${archive_fmt}";
        url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
        inherit hash;
      };
      postPatch = builtins.replaceStrings [ oldRipgrepPath ] [ newRipgrepPath ] old.postPatch;
    }
  );
}
