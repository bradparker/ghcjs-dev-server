{ compiler
, nixpkgs
}:
let
  packages = if compiler == "default"
    then nixpkgs.haskellPackages
    else nixpkgs.haskell.packages.${compiler};
in
  [
    nixpkgs.direnv
    packages.cabal-install
    packages.ghcid
    packages.hindent
    packages.hlint
  ]
