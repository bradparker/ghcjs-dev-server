{ nixpkgs ? import ./nix/nixpkgs.nix {} }:
let
  packages = nixpkgs.haskell.packages.ghc802;

  hlint = packages.hlint;
  hindent = packages.hindent;
  cabal = packages.cabal-install;

  default = (import ./default.nix { inherit nixpkgs; });
  serverEnvAttrs = default.server.env.drvAttrs;
  clientEnvAttrs = default.client.env.drvAttrs;

  merged = serverEnvAttrs // {
    name = "ghcjs-dev-env";
    nativeBuildInputs =
      serverEnvAttrs.nativeBuildInputs ++
      clientEnvAttrs.nativeBuildInputs ++
      [
        cabal
        hindent
        hlint
      ];
    shellHook = serverEnvAttrs.shellHook + clientEnvAttrs.shellHook;
  };
in
  nixpkgs.stdenv.mkDerivation merged
