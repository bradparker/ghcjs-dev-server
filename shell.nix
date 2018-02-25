with import <nixpkgs> {};
{ nixpkgs ? import (fetchgit {
    inherit (builtins.fromJSON (builtins.readFile ./nixpkgs.json)) url rev sha256;
  }) {},
  compiler ? "default" }:
let
  haskellPackages = if compiler == "default"
    then nixpkgs.haskellPackages
    else nixpkgs.pkgs.haskell.packages.${compiler};
  hlint = haskellPackages.hlint;
  cabal = haskellPackages.cabal-install;

  default = (import ./default.nix { inherit nixpkgs compiler; });
  serverEnvAttrs = default.server.env.drvAttrs;
  clientEnvAttrs = default.client.env.drvAttrs;

  merged = serverEnvAttrs // {
    name = "ghcjs-dev-env";
    nativeBuildInputs = serverEnvAttrs.nativeBuildInputs ++ clientEnvAttrs.nativeBuildInputs;
    shellHook = serverEnvAttrs.shellHook + clientEnvAttrs.shellHook;
  };
in
  nixpkgs.stdenv.mkDerivation merged
