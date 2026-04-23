{ inputs, system, ... }:
if system == "aarch64-darwin" then
  inputs.nix-darwin.packages.aarch64-darwin.darwin-rebuild
else
  # HACK: This is only available on macOS but blueprint tries to instantiate this on all
  # platforms by default
  {
    type = "derivation";
    name = "darwin-rebuild";
  }
