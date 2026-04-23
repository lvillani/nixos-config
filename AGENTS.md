# Agent Notes

## Architecture

This flake uses [numtide/blueprint](https://github.com/numtide/blueprint) for
convention-over-configuration output generation. `flake.nix` only declares inputs and
calls `inputs.blueprint { inherit inputs; ... }`; blueprint auto-discovers all outputs
from the directory layout.

Three deployment modes are supported:

- **NixOS** (`nixosConfigurations.*`): full system config, home-manager wired in per
  host.
- **nix-darwin** (`darwinConfigurations.*`): full system config on macOS, home-manager
  wired in per host.
- **Standalone home-manager**: user environment only, no system config (Linux
  non-NixOS).

## Blueprint Directory Conventions

Blueprint discovers outputs by directory layout. The conventions used in this repo:

| Path                                    | Blueprint output                          |
| --------------------------------------- | ----------------------------------------- |
| `hosts/<name>/configuration.nix`        | `nixosConfigurations.<name>`              |
| `hosts/<name>/darwin-configuration.nix` | `darwinConfigurations.<name>`             |
| `hosts/<name>/users/<user>.nix`         | home-manager config for `<user>` on host  |
| `modules/nixos/<name>.nix`              | `nixosModules.<name>`                     |
| `modules/home/<name>.nix`               | `homeModules.<name>`                      |
| `modules/<dir>/<name>.nix`              | `modules.<dir>.<name>` (custom namespace) |
| `packages/<name>.nix`                   | `packages.<system>.<name>`                |
| `overlays/default.nix`                  | applied overlay                           |

Cross-module references use `inputs.self.*`, e.g. `inputs.self.nixosModules.base`.

## Key Files

| File                                             | Purpose                                              |
| ------------------------------------------------ | ---------------------------------------------------- |
| `flake.nix`                                      | Inputs and blueprint invocation (no manual outputs)  |
| `modules/home/home-shared.nix`                   | Shared home-manager configuration (all modes)        |
| `modules/nixos-and-darwin/shared.nix`            | Shared system-level config (NixOS + nix-darwin only) |
| `modules/nixos/base.nix`                         | NixOS headless base config                           |
| `modules/nixos/gnome.nix`                        | GNOME desktop additions for NixOS                    |
| `hosts/base-darwin/darwin-configuration.nix`     | macOS host config                                    |
| `hosts/base-nixos/configuration.nix`             | Headless NixOS host                                  |
| `hosts/base-nixos-framework13/configuration.nix` | Framework 13 NixOS host                              |
| `hosts/*/users/user.nix`                         | Per-host home-manager user config                    |
| `overlays/default.nix`                           | Exposes `pkgs.unstable` from `nixpkgs-unstable`      |

## Overlays

`pkgs.unstable` (from `nixpkgs-unstable`) is exposed via `overlays/default.nix` and
applied globally in `flake.nix` via the `nixpkgs.overlays` argument to blueprint. This
makes `pkgs.unstable` available in all modes (NixOS, nix-darwin, and standalone
home-manager) without any per-module guards. `nixpkgs.config.allowUnfree` is also set
globally in `flake.nix`; no per-module `nixpkgs` settings are needed.

## Host Configurations

| Host directory                 | Kind       | Description                                                              |
| ------------------------------ | ---------- | ------------------------------------------------------------------------ |
| `hosts/base-nixos`             | NixOS      | Headless / server — imports `nixosModules.base`                          |
| `hosts/base-nixos-framework13` | NixOS      | GNOME + Framework 13 AMD — imports `nixosModules.gnome` + nixos-hardware |
| `hosts/base-darwin`            | nix-darwin | macOS — imports `modules.nixos-and-darwin.shared`                        |

## Applying Changes

The `script/setup-nix` bootstrap script handles first-time setup and switching across
all modes:

| Environment                       | Command run by the script                                    |
| --------------------------------- | ------------------------------------------------------------ |
| macOS                             | `nix run path:.#darwin-rebuild -- switch --flake path:.`     |
| NixOS (detected via `/etc/NIXOS`) | `sudo nix run path:.#nixos-rebuild -- switch --flake path:.` |
| Linux standalone                  | `nix run path:.#home-manager -- switch --flake path:.`       |

The `nixos-rebuild`, `darwin-rebuild`, and `home-manager` binaries are re-exported as
flake packages (under `packages/`) so no prior installation is needed.

## Nix Settings

Channels are disabled (`nix.channel.enable = false`); `nix.nixPath` is set in
`modules/home/home-shared.nix` to point to the flake's `nixpkgs` input. Automatic GC and
store optimisation are enabled in `modules/nixos-and-darwin/shared.nix` for system
modes.

## home-shared.nix Conventions

- `isHomeManagerStandalone` — `true` when `osConfig == null` (standalone mode). Use this
  to gate options that are only valid or needed without a parent system config.
- `vscodeUserDirectory` — platform-aware path helper for Darwin vs. Linux VS Code
  config.
- `targets.genericLinux.enable` is set only in standalone mode, since NixOS/nix-darwin
  manage this themselves.
