{ inputs }:
final: prev:
let
  isDarwinAarch64 = prev.stdenv.hostPlatform.isDarwin && prev.stdenv.hostPlatform.isAarch64;
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
