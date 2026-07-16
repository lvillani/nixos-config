---
name: nix
description: Read this skill when working with Nix.
---

## Reference Links

When you need to find packages, options, or function documentation, use these resources:

| Resource                      | URL                                                                      |
| ----------------------------- | ------------------------------------------------------------------------ |
| Nix packages (stable)         | `https://search.nixos.org/packages?query=<package>`                      |
| Nix packages (unstable)       | `https://search.nixos.org/packages?channel=unstable&query=<package>`     |
| NixOS options                 | `https://search.nixos.org/options?query=<option>`                        |
| Home Manager options          | `https://search.nixos.org/options?source=home_manager&query=<option>`    |
| Modular service options       | `https://search.nixos.org/options?source=modular_service&query=<option>` |
| Nix/nixpkgs library functions | `https://noogle.dev`                                                     |

The search.nixos.org package results may link to the nixpkgs source, which shows the
exact Nix expression used to build a package. Use these links to understand package
structure, available options, and dependencies.

By default search.nixos.org returns results for the stable channel. Specify
`channel=unstable` to look for the unstable branch.

## Blueprint

If the flake has a `blueprint` input it uses Numtide's Blueprint for a standardized
folder structure. In that case, read the following files for reference:

- `blueprint/folder_structure.md` — standard directory layout (hosts/, modules/,
  packages/, lib/, etc.)
- `blueprint/configuration.md` — flake.nix output options (prefix, systems,
  nixpkgs.config, nixpkgs.overlays)

## Tips for Editing

- Read the existing flake.nix before making changes to understand the project's
  input/output structure.

## Hashes

`nix-prefetch-url` prints raw **hex** (64 chars). Nix derivations usually want
**SRI base64** (`sha256-<base64>=`). Convert with `nix hash convert --to sri sha256:<hex>`.
