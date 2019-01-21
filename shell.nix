{ nixpkgs ? import ./nix/packages/nixpkgs }:
let
  default = (import ./default.nix { inherit nixpkgs; });
  serverEnvAttrs = default.server.env.drvAttrs;
  clientEnvAttrs = default.client.env.drvAttrs;

  merged = serverEnvAttrs // {
    name = "ghcjs-dev-env";
    nativeBuildInputs =
      serverEnvAttrs.nativeBuildInputs ++
      clientEnvAttrs.nativeBuildInputs;
  };
in
  nixpkgs.stdenv.mkDerivation merged
