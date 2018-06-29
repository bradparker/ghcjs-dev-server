# GHCJS Dev Server

*N.B.* This is an experiment. There is a lot of work to do and a lot of questions to answer :)

At the momement it just does a couple of things:

* Recompiles a GHCJS project on source change
* On recompile sends a websocket message to connected browsers which can be used to reload

## Development

```
$ nix-shell
$ cd server
$ cabal configure && cabal build
$ cd ../sample-app
$ ../server/dist/build/ghcjs-dev-server/ghcjs-dev-server -s src -s ../client/src/ -x OverloadedStrings
```

You should now have the sample app available at http://localhost:8080. If you edit a Haskell file in the `sample-app/src` directory then the browser should reload with your new code.
