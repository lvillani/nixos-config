# Agent Notes

## Architecture

This flake supports three deployment modes:

- **NixOS** (`nixosConfigurations.*`): full system config, home-manager as a NixOS
  module.
- **nix-darwin** (`darwinConfigurations.*`): full system config on macOS, home-manager
  as a darwin module.
- **Standalone home-manager** (`packages.*.homeConfigurations.base`): user environment
  only, no system config.

## Key Files

| File                            | Purpose                                              |
| ------------------------------- | ---------------------------------------------------- |
| `flake.nix`                     | Inputs, outputs, and configuration entry points      |
| `home.nix`                      | Shared home-manager configuration (all modes)        |
| `configuration/common.nix`      | Shared system-level config (NixOS + nix-darwin only) |
| `configuration/nixos.nix`       | NixOS-specific system config                         |
| `configuration/nixos-gnome.nix` | GNOME desktop additions for NixOS                    |
| `configuration/darwin.nix`      | macOS-specific system config                         |

## Overlays

`pkgs.unstable` (from `nixpkgs-unstable`) is exposed via an overlay:

- In **NixOS / nix-darwin**: the overlay is set in `configuration/common.nix` via
  `nixpkgs.overlays`. Because `home-manager.useGlobalPkgs = true` is set there,
  `home.nix` inherits the same `pkgs` and `pkgs.unstable` is available without any extra
  setup.
- In **standalone home-manager**: the overlay is set in `home.nix` itself, guarded by
  `lib.mkIf isHomeManagerStandalone` to avoid a double-apply in the other two modes.

## NixOS Configurations

There are three NixOS configurations, all built from the same base modules:

- `base` — headless / server setup.
- `base-gnome` — adds `configuration/nixos-gnome.nix` for GNOME + GDM + PipeWire +
  NetworkManager.
- `base-gnome-framework` — same as above, plus the `nixos-hardware` Framework 13 AMD
  module.

## Applying Changes

The `script/setup-nix` bootstrap script handles first-time setup and switching across
all modes:

| Environment                       | Command run by the script                                    |
| --------------------------------- | ------------------------------------------------------------ |
| macOS                             | `nix run path:.#darwin-rebuild -- switch --flake path:.`     |
| NixOS (detected via `/etc/NIXOS`) | `sudo nix run path:.#nixos-rebuild -- switch --flake path:.` |
| Linux standalone                  | `nix run path:.#home-manager -- switch --flake path:.`       |

The `nixos-rebuild`, `darwin-rebuild`, and `home-manager` binaries are all re-exported
as flake packages so no prior installation is needed.

## Nix Settings

Channels are disabled (`nix.channel.enable = false`); `nix.nixPath` is set in `home.nix`
to point directly to the flake's `nixpkgs` input. Automatic GC and store optimisation
are enabled in `common.nix` for system modes.

## home.nix Conventions

- `isHomeManagerStandalone` — `true` when `osConfig == null` (standalone mode). Use this
  to gate options that are only valid or needed without a parent system config.
- `homeDirectory` / `vscodeUserDirectory` — platform-aware path helpers for Darwin vs.
  Linux.
- `targets.genericLinux.enable` is set only in standalone mode, since NixOS/nix-darwin
  manage this themselves.
