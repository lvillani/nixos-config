{ inputs }:
final: prev:
{
  unstable = import inputs.nixpkgs-unstable {
    inherit (prev.stdenv.hostPlatform) system;
    inherit (prev) config;
  };

  pi-coding-agent = final.unstable.pi-coding-agent;

  # Work around https://github.com/NixOS/nixpkgs/issues/560776.
  vscode =
    if final.stdenv.isLinux then
      final.unstable.vscode.overrideAttrs (old: {
        postPatch = old.postPatch + ''
          ln -s node_modules resources/app/node_modules.asar.unpacked
        '';
      })
    else
      final.unstable.vscode;
}
