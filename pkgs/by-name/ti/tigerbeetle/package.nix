{
  lib,
  stdenvNoCC,
  fetchzip,
  testers,
  tigerbeetle,
  nix-update-script,
}:
let
  platform =
    if stdenvNoCC.hostPlatform.isDarwin then "universal-macos" else stdenvNoCC.hostPlatform.system;
  hash = builtins.getAttr platform {
    "universal-macos" = "sha256-SS2PPniO3zSfDyCy3aM41Jq8HlOuIQj4hFUx7tUlOzM=";
    "x86_64-linux" = "sha256-sE0P8mLvz8V45z2qGP4cAlzow58lc483+dDIbOwvC0Y=";
    "aarch64-linux" = "sha256-W8AWgG86/MFM/xpxEIjkjeVWsCN0Mjme60geusFwMRo=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tigerbeetle";
  version = "0.16.8";

  src = fetchzip {
    url = "https://github.com/tigerbeetle/tigerbeetle/releases/download/${finalAttrs.version}/tigerbeetle-${platform}.zip";
    inherit hash;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src/tigerbeetle $out/bin/tigerbeetle

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = tigerbeetle;
      command = "tigerbeetle version";
    };
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://tigerbeetle.com/";
    description = "Financial accounting database designed to be distributed and fast";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      danielsidhion
      nwjsmith
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ] ++ lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "tigerbeetle";
  };
})
