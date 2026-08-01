{
  pkgs,
  system,
  ...
}:

pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "omp-bin";
  version = "17.2.2";

  src =
    let
      sources = {
        x86_64-linux = {
          url = "https://github.com/can1357/oh-my-pi/releases/download/v${finalAttrs.version}/omp-linux-x64";
          hash = "sha256-MG9VVjfWPc7YDP+y/pCNp+BUOJ+FjAcfMEvBfj7WIt4=";
        };
        aarch64-linux = {
          url = "https://github.com/can1357/oh-my-pi/releases/download/v${finalAttrs.version}/omp-linux-arm64";
          hash = "sha256-BE5AXcNA0YYroaY00g7FxgCkDg7yQiG72z2zc7H+OtU=";
        };
        x86_64-darwin = {
          url = "https://github.com/can1357/oh-my-pi/releases/download/v${finalAttrs.version}/omp-darwin-x64";
          hash = "sha256-0Jm/sqGCcQ+uA/xeqnTn6XTmXzi4B5sbeYuXbRuVRKk=";
        };
        aarch64-darwin = {
          url = "https://github.com/can1357/oh-my-pi/releases/download/v${finalAttrs.version}/omp-darwin-arm64";
          hash = "sha256-M/WYC5YBfsIN0AL6xsiljW9kHtAY8gVO+4s8Fso0OAQ=";
        };
      };
    in
    pkgs.fetchurl (
      sources.${system} or (throw "Unsupported system: ${system}")
    );

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;

  nativeBuildInputs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pkgs.autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/omp

    runHook postInstall
  '';

  # strip removes the embedded JS bundle from the bun-compiled binary
  dontStrip = true;

  nativeInstallCheckInputs = [
    pkgs.versionCheckHook
    pkgs.writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;

  passthru = {
    tests.version = pkgs.testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    updateScript = pkgs.nix-update-script { };
  };

  meta = {
    description = "Coding agent for the terminal with LSP, debugging, and multi-provider LLM support";
    homepage = "https://omp.sh";
    changelog = "https://github.com/can1357/oh-my-pi/releases/tag/v${finalAttrs.version}";
    license = pkgs.lib.licenses.mit;
    maintainers = [ pkgs.lib.maintainers.gdifolco ];
    mainProgram = "omp";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
  };
})
