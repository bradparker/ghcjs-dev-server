let
  nixpkgs = import ../../nix/packages/nixpkgs;
  ghcjs-dev-client = nixpkgs.haskell.packages.ghcjs.callCabal2nix "ghcjs-dev-client" ../../client {};
  ghcjs-dev-server = nixpkgs.haskellPackages.callCabal2nix "ghcjs-dev-server" ../../server {};
  serverPackages = nixpkgs.haskellPackages;
  clientPackages = nixpkgs.haskell.packages.ghcjs;
  server = serverPackages.callCabal2nix "server" ./server {
    inherit ghcjs-dev-server;
    common = serverPackages.callCabal2nix "common" ./common {};
  };
  client = clientPackages.callCabal2nix "client" ./client {
    inherit ghcjs-dev-client;
    common = clientPackages.callCabal2nix "common" ./common {};
  };
in
  { inherit client server; }
