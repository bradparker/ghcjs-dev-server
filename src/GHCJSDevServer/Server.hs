module GHCJSDevServer.Server
  ( ghcjsServer
  , runGHCJSServer
  ) where

import           Data.Bool                      (bool)
import           Data.ByteString.Lazy           (ByteString)
import           GHCJSDevServer.Options         (Options (..),
                                                 ServerOptions (..))
import           Lucid                          as L
import           Lucid.Base                     (makeAttribute)
import           Network.HTTP.Types             (status200)
import           Network.Wai                    (Application, rawPathInfo,
                                                 responseLBS)
import           Network.Wai.Application.Static (StaticSettings (..),
                                                 defaultWebAppSettings,
                                                 staticApp)
import           Network.Wai.Handler.Warp       (run)
import           System.FilePath                (hasExtension)
import           System.FilePath                ((</>))
import           WaiAppStatic.Types             (MaxAge (..))

ghcjsServer :: Options -> Application
ghcjsServer options request respond =
  bool
    (root request respond)
    (static options request respond)
    (hasExtension (show (rawPathInfo request)))

runGHCJSServer :: Options -> IO ()
runGHCJSServer options = run (_port (_server options)) (ghcjsServer options)

static :: Options -> Application
static options =
  staticApp
    ((defaultWebAppSettings (_output options </> "app.jsexe"))
     {ssMaxAge = NoMaxAge})

document :: ByteString
document =
  L.renderBS $
  L.doctypehtml_ $ do
    L.head_ $ do
      L.with (L.meta_ mempty) [makeAttribute "charset" "utf8"]
      scriptRef "/rts.js"
      scriptRef "/lib.js"
      scriptRef "/out.js"
    L.body_ $ do
      scriptRef "/runmain.js"
      L.script_
        "\nconst socket = new WebSocket('ws://localhost:8081');\n\
        \socket.addEventListener('open', function (event) {\n\
        \  console.log('[GHCJSDS] Connected');\n\
        \});\n\
        \socket.addEventListener('close', function (event) {\n\
        \  console.log('[GHCJSDS] Dsconnected');\n\
        \});\n\
        \socket.addEventListener('message', function (event) {\n\
        \  console.log('[GHCJSDS] Message from server ', event.data);\n\
        \  location.reload(true);\n\
        \});\n\
        \window.addEventListener('beforeunload', function () {\n\
        \  socket.close();\n\
        \});"
  where
    scriptRef src = L.with (L.script_ mempty) [makeAttribute "src" src]

root :: Application
root _ respond =
  respond (responseLBS status200 [("Content-type", "text/html")] document)
