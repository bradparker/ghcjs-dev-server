{ nixpkgs ? import ./nix/packages/nixpkgs {} }:
let
  serverPackages = nixpkgs.haskell.packages.ghc843;
  clientPackages = nixpkgs.haskell.packages.ghcjs84;
  server = serverPackages.callPackage ./server/package.nix { };
  client = clientPackages.callPackage ./client/package.nix { };
in
  { inherit client server; }
