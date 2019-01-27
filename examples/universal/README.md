# GHCJS Dev Server - Universal Example

In this directory, run (you don't want to be in an existing `nix-shell` already).

```
$ nix-shell --run "ghcid server/dev/Main.hs --test='Main.main'"
```

You should now be able to visit http://localhost:8080 and see a pretty rockin' website (:D). You'll be greeted by a message both on the page itself (sent from the server), and in the javascript console (logged by the client). Enjoy.

Now when you make changes to files in `common`, `server` and `client` it'll automatically recompile and reload your browser with the new back end and front end code.

## How?

If you change some client-side code (files in `client`) then the GHCJS Watcher will pick that up and run a recompilation using `ghcjs`. When it's done it'll publish a message that is picked up by the GHCJS Notifier which will send a message to the browser via a web socket. When the GHCJS Dev Client code receives this message it reloads the browser.

If you change some server-side code (files in `server`) then `ghcid` does it's thing and reloads. When the server side code starts again it also starts all the GHCJS code again, so it'll recompile the front end stuff also. When the front end is finished compiling the usual web socket dance happens and the browser is reloaded. 

When the server is recompiled by `ghcid` it disconnects the browser's web socket, the GHCJS Dev Client will continuously try to reconnect so that when the server is ready it can receive the message that the client-side code has finished compiling.
