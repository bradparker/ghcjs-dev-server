{ nixpkgs ? import ./nix/packages/nixpkgs }:
let
  serverPackages = nixpkgs.haskellPackages;
  clientPackages = nixpkgs.haskell.packages.ghcjs;
  server = serverPackages.callCabal2nix "ghcjs-dev-server" ./server { };
  client = clientPackages.callCabal2nix "ghcjs-dev-client" ./client { };
in
  { inherit client server; }
