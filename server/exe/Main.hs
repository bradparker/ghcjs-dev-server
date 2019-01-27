module Main
  ( main
  ) where

import Control.Concurrent (forkIO)
import Control.Concurrent.STM (TChan, atomically, dupTChan, readTChan)
import Control.Monad (forever)
import Data.Functor (void)
import qualified GHCJSDevServer
import Network.HTTP.Types (status200)
import Network.Wai (Application, responseFile)
import qualified Network.Wai.Handler.Warp as Warp
import System.FilePath ((</>))
import System.IO.Temp (withTempDirectory)

makeApp :: String -> Application
makeApp outputDir _req respond =
  respond $ responseFile status200 [] (outputDir </> "index.html") Nothing

serverLogger :: Int -> TChan (Either String String) -> IO ()
serverLogger port bchan = do
 chan <- atomically $ dupTChan bchan
 forever $ do
   message <- atomically $ readTChan chan
   GHCJSDevServer.logger port message

main :: IO ()
main =
  withTempDirectory "." "ghcjsds-build" $ \tempDir -> do
    serverOptions <- GHCJSDevServer.getOptions tempDir
    let options = GHCJSDevServer.options serverOptions
    let port = GHCJSDevServer.port serverOptions
    (chan, middleware) <- GHCJSDevServer.makeMiddleware options
    let app = middleware $ makeApp $ GHCJSDevServer.outputDirectory options
    void $ forkIO $ Warp.run port app
    serverLogger port chan
