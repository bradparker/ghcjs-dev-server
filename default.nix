with import <nixpkgs> {};
{ nixpkgs ? import (fetchgit {
    inherit (builtins.fromJSON (builtins.readFile ./nixpkgs.json)) url rev sha256;
  }) {},
  compiler ? "default" }:
let
  haskellPackages = if compiler == "default"
    then nixpkgs.haskellPackages
    else nixpkgs.haskell.packages.${compiler};
  server = haskellPackages.callPackage ./server/package.nix { };
  client = haskell.packages.ghcjs.callPackage ./client/package.nix { };
in
  { inherit client server; }
