{ nixpkgs ? import ./nix/nixpkgs.nix {} }:
let
  serverPackages = nixpkgs.haskell.packages.ghc802;
  clientPackages = nixpkgs.haskell.packages.ghcjs80;
  server = serverPackages.callPackage ./server/package.nix { };
  client = clientPackages.callPackage ./client/package.nix { };
in
  { inherit client server; }
