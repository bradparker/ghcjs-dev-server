let
  nixpkgs = import ../../nix/packages/nixpkgs;
  ghcjs-dev-client = nixpkgs.haskell.packages.ghcjs.callPackage ../../client/package.nix {};
  ghcjs-dev-server = nixpkgs.haskellPackages.callPackage ../../server/package.nix {};
  package = nixpkgs.haskell.packages.ghcjs.callCabal2nix "ghcjs-dev-server-examples-simple" ./. {
    inherit ghcjs-dev-client;
  };
in
  nixpkgs.haskell.lib.addBuildDepends package [ghcjs-dev-server]
