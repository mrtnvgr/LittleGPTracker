{ pkgs ? import <nixpkgs> {} }: {
  lgpt = pkgs.callPackage ./lgpt.nix {
    inherit (pkgs.darwin.apple_sdk.frameworks) Foundation;
  };
}
