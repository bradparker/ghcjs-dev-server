with import <nixpkgs> {};
{ nixpkgs ? import (fetchgit {
    inherit (builtins.fromJSON (builtins.readFile ./nixpkgs.json)) url rev sha256;
  }) {},
  compiler ? "default" }:
let
  haskellPackages = if compiler == "default"
    then nixpkgs.haskellPackages
    else nixpkgs.pkgs.haskell.packages.${compiler};
  env = (import ./default.nix { inherit nixpkgs compiler; }).env;
  hlint = haskellPackages.hlint;
  cabal = haskellPackages.cabal-install;
  ghcjs = haskell.compiler.ghcjs;
in
  nixpkgs.lib.overrideDerivation env (drv: {
    nativeBuildInputs = drv.nativeBuildInputs ++ [ hlint cabal ghcjs ];
  })
