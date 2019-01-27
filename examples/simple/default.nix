let
  nixpkgs = import ../../nix/packages/nixpkgs;
  ghcjs-dev-client = nixpkgs.haskell.packages.ghcjs.callCabal2nix "ghcjs-dev-client" ../../client {};
  ghcjs-dev-server = nixpkgs.haskellPackages.callCabal2nix "ghcjs-dev-server" ../../server {};
  package = nixpkgs.haskell.packages.ghcjs.callCabal2nix "simple" ./. {
    inherit ghcjs-dev-client;
  };
in
  nixpkgs.haskell.lib.addBuildDepends package [ghcjs-dev-server]
