{ inputs, system, ... }:
let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
pkgs.writeShellApplication {
  name = "deploy";
  runtimeInputs = [ pkgs.nh ];
  text = builtins.readFile ./script/deploy;
}
