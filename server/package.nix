{ mkDerivation, aeson, ansi-terminal, base, bytestring, directory
, filepath, fsnotify, optparse-applicative, process, stdenv, stm
, wai, wai-app-static, warp, websockets
}:
mkDerivation {
  pname = "ghcjs-dev-server";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson ansi-terminal base bytestring directory filepath fsnotify
    optparse-applicative process stm wai wai-app-static warp websockets
  ];
  license = stdenv.lib.licenses.bsd3;
}
