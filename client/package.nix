{ mkDerivation, base, ghcjs-base, stdenv }:
mkDerivation {
  pname = "ghcjs-dev-client";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [ base ghcjs-base ];
  license = stdenv.lib.licenses.bsd3;
}
