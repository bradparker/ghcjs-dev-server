{ mkDerivation, base, bytestring, directory, filepath, fsnotify
, http-types, lucid, optparse-applicative, process, stdenv, stm
, wai, wai-app-static, warp, websockets
}:
mkDerivation {
  pname = "ghcjs-dev-server";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base bytestring directory filepath fsnotify http-types lucid
    optparse-applicative process stm wai wai-app-static warp websockets
  ];
  license = stdenv.lib.licenses.bsd3;
}
