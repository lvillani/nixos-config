# Agent Notes

## Architecture

This flake uses [numtide/blueprint](https://github.com/numtide/blueprint) for
convention-over-configuration output generation. `flake.nix` only declares inputs and
calls `inputs.blueprint { inherit inputs; ... }`; blueprint auto-discovers all outputs
from the directory layout. Cross-module references use `inputs.self.*`, e.g.
`inputs.self.nixosModules.base`.

## Key Files

| File                                  | Purpose                                                |
| ------------------------------------- | ------------------------------------------------------ |
| `package.nix`                         | Default flake package; wraps `script/deploy` with `nh` |
| `modules/home/home-shared.nix`        | Shared home-manager configuration (all modes)          |
| `modules/nixos-and-darwin/shared.nix` | Shared system-level config (NixOS + nix-darwin only)   |
| `script/bootstrap`                    | First-time setup: installs Nix if absent, then deploys |
| `script/deploy`                       | Switches the active config using `nh`                  |

`pkgs.unstable` and `nixpkgs.config.allowUnfree` are set globally in `flake.nix`; no
per-module guards needed.

## Host Configurations

| Host directory                 | Kind       | Description                                                              |
| ------------------------------ | ---------- | ------------------------------------------------------------------------ |
| `hosts/base-nixos`             | NixOS      | Headless / server — imports `nixosModules.base`                          |
| `hosts/base-nixos-framework13` | NixOS      | GNOME + Framework 13 AMD — imports `nixosModules.gnome` + nixos-hardware |
| `hosts/base-darwin`            | nix-darwin | macOS — imports `modules.nixos-and-darwin.shared`                        |

## Applying Changes

`script/bootstrap` installs Nix if absent. For day-to-day use, run `nix run path:.`
(the default package wraps `script/deploy` with `nh` as a runtime dep).

| Environment                       | Command run by `script/deploy` |
| --------------------------------- | ------------------------------ |
| macOS                             | `nh darwin switch path:.`      |
| NixOS (detected via `/etc/NIXOS`) | `nh os switch path:.`          |
| Linux standalone                  | `nh home switch path:.`        |

## home-shared.nix Conventions

- `isHomeManagerStandalone` — `true` when `osConfig == null` (standalone mode). Use this
  to gate options that are only valid or needed without a parent system config.
- `vscodeUserDirectory` — platform-aware path helper for Darwin vs. Linux VS Code
  config.
