{ nixpkgs ? import ./nix/packages/nixpkgs }:
let
  serverPackages = nixpkgs.haskellPackages;
  clientPackages = nixpkgs.haskell.packages.ghcjs;
  server = serverPackages.callPackage ./server/package.nix { };
  client = clientPackages.callPackage ./client/package.nix { };
in
  { inherit client server; }
