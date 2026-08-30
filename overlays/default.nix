{ inputs }:
final: prev:
{
  unstable = import inputs.nixpkgs-unstable {
    inherit (prev.stdenv.hostPlatform) system;
    inherit (prev) config;
  };

  pi-coding-agent = final.unstable.pi-coding-agent.overrideAttrs (old: rec {
    version = "0.84.4";
    src = final.fetchFromGitHub {
      owner = "earendil-works";
      repo = "pi";
      tag = "v${version}";
      hash = "sha256-7z8OXao1PzmBEepDkIqVqyfQBPHulBlKcGymDYsnMvc=";
    };
    npmDeps = final.fetchNpmDeps {
      inherit src;
      name = "pi-coding-agent-${version}-npm-deps";
      hash = "sha256-35GC3Q4Jf4URvqoEYHeM63x49tTmrth62//PvKm4I7Q=";
    };
    modelData = final.fetchurl {
      url = "https://registry.npmjs.org/@earendil-works/pi-ai/-/pi-ai-${version}.tgz";
      hash = "sha256-39PJKc7lpzhxmaCiTfwb4glvHqj1n/uChRmKDtAev5M=";
    };
  });

  vscode = final.unstable.vscode;
}
