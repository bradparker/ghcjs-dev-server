{ nixpkgs ? import ./nix/packages/nixpkgs {} }:
let
  default = (import ./default.nix { inherit nixpkgs; });
  serverEnvAttrs = default.server.env.drvAttrs;
  clientEnvAttrs = default.client.env.drvAttrs;

  tools = import ./nix/tools.nix { compiler = "ghc843"; inherit nixpkgs; };

  merged = serverEnvAttrs // {
    name = "ghcjs-dev-env";
    nativeBuildInputs =
      serverEnvAttrs.nativeBuildInputs ++
      clientEnvAttrs.nativeBuildInputs ++
      tools;
    shellHook = serverEnvAttrs.shellHook + clientEnvAttrs.shellHook;
  };
in
  nixpkgs.stdenv.mkDerivation merged
