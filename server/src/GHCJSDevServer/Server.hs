module GHCJSDevServer.Server
  ( ghcjsServer
  , runGHCJSServer
  ) where

import           GHCJSDevServer.Options         (Options (..),
                                                 ServerOptions (..))
import           Network.Wai                    (Application)
import           Network.Wai.Application.Static (StaticSettings (..),
                                                 defaultWebAppSettings,
                                                 staticApp)
import           Network.Wai.Handler.Warp       (run)
import           System.FilePath                ((</>))
import           WaiAppStatic.Types             (MaxAge (..), unsafeToPiece)

ghcjsServer :: Options -> Application
ghcjsServer = static

runGHCJSServer :: Options -> IO ()
runGHCJSServer options = run (_port (_server options)) (ghcjsServer options)

static :: Options -> Application
static options =
  staticApp
    ((defaultWebAppSettings (_output options </> "app.jsexe"))
     {ssMaxAge = NoMaxAge, ssIndices = [unsafeToPiece "index.html"]})
