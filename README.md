# ❄️ nixos-config

> This is my NixOS config. There are many like it, but this one is mine.

My base system configurations as a Nix flake, covering:

- 🐧 NixOS
- 🍎 macOS (via nix-darwin)
- 🏠 Home Manager (standalone)

Private machine-specific configs build on top of these.

## Usage

Reference this flake as an input and extend the base configurations with your
machine-specific modules.

```nix
# flake.nix
{
  inputs = {
    nixos-config.url = "github:lvillani/nixos-config";
  };

  outputs = inputs: {
    # Re-export packages to allow `nix run path:.` to apply the configuration.
    inherit (inputs.nixos-config) packages;

    # NixOS
    nixosConfigurations.my-machine = inputs.nixos-config.nixosConfigurations.base-nixos.extendModules {
      modules = [ ./hosts/my-machine/configuration.nix ];
    };

    # macOS (nix-darwin)
    darwinConfigurations.my-mac = inputs.nixos-config.darwinConfigurations.base-darwin.extendModules {
      modules = [ ./hosts/my-mac/darwin-configuration.nix ];
    };
  };
}
```

Available base configurations to extend:

| Output                                       | Description                           |
| -------------------------------------------- | ------------------------------------- |
| `nixosConfigurations.base-nixos`             | Base NixOS configuration              |
| `nixosConfigurations.base-nixos-framework13` | NixOS for Framework 13 laptops        |
| `darwinConfigurations.base-darwin`           | Base macOS (nix-darwin) configuration |

## Home Manager

[blueprint](https://github.com/numtide/blueprint) publishes Home Manager configurations
under `legacyPackages` rather than `homeConfigurations`. To extend one, pick the
`user@base-<variant>` that matches your target system:

```nix
outputs = inputs: {
homeConfigurations."user@my-machine" =
    inputs.nixos-config.legacyPackages.x86_64-linux.homeConfigurations."user@base-nixos".extendModules
    {
        modules = [ ./home.nix ];
    };
};
```
