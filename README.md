# GHCJS Dev Server

*N.B.* This is an experiment. There is a lot of work to do and a lot of questions to answer :)

At the momement it just does a couple of things:

* Recompiles a GHCJS project on source change
* On recompile sends a websocket message to connected browsers which can be used to reload

Please enjoy this very low quality and hastily made gif of running the [Universal example](examples/universal)

![Working on the Universal Example](docs/example.gif)

## Development

```
$ nix-shell
$ cd server
# Dev, dev, dev
$ cd ../client
# Dev, dev, dev
$ cd ../examples/simple
$ nix-shell --pure -A env --run "ghcjs-dev-server -s src"
```

You should now have the sample app available at http://localhost:8080. If you edit a Haskell file in the `examples/simple/src` directory then the browser should reload with your new code.
