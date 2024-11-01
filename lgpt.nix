{ lib, stdenv
, SDL2
, python3
, jack2
, Foundation
, alsa-lib
, pkg-config
}:
let
  python = python3.withPackages (ps: with ps; [ pillow ]);
  platform = if stdenv.isLinux then "X64" else "OSX";
in stdenv.mkDerivation {
  pname = "littlegptracker";
  version = "unstable-xxxx";

  src = ./.;

  buildInputs = [
    pkg-config
    SDL2
    python
    alsa-lib
  ]
  ++ lib.optional stdenv.isDarwin Foundation
  ++ lib.optional stdenv.isLinux jack2;

  preBuild = "cd projects";

  makeFlags = [ "PLATFORM=${platform}" ];

  NIX_LDFLAGS = lib.optional stdenv.isDarwin "-framework Foundation";

  installPhase = let extension = if stdenv.isDarwin then "app" else "x64"; in ''
    runHook preInstall
    install -Dsm555 lgpt.${extension} $out/lib/lgpt/lgpt
    install -Dm444 resources/${platform}/{config,mapping}.xml $out/lib/lgpt/
    mkdir -p $out/bin
    ln -s $out/lib/lgpt/lgpt $out/bin/
    runHook postInstall
  '';
}
