let
  nixpkgs = import ../../nix/packages/nixpkgs;
  default = import ./default.nix;
  serverEnvAttrs = default.server.env.drvAttrs;
  clientEnvAttrs = default.client.env.drvAttrs;

  merged = serverEnvAttrs // {
    name = "ghcjs-dev-examples-universal-env";
    nativeBuildInputs =
      serverEnvAttrs.nativeBuildInputs ++
      clientEnvAttrs.nativeBuildInputs;
  };
in
  nixpkgs.stdenv.mkDerivation merged
