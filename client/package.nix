{ mkDerivation, aeson, base, bytestring, ghcjs-base, stdenv }:
mkDerivation {
  pname = "ghcjs-dev-client";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [ aeson base bytestring ghcjs-base ];
  license = stdenv.lib.licenses.bsd3;
}
