module Main
  ( main
  ) where

import Control.Concurrent (forkIO)
import Control.Concurrent.STM (atomically, newBroadcastTChan)
import Control.Monad (void)
import GHCJSDevServer
  ( Options(..)
  , ServerOptions(..)
  , getOptions
  , middleware
  , runGHCJSLogger
  , runGHCJSWatcher
  )
import Network.HTTP.Types (status200)
import Network.Wai (Application, responseFile)
import Network.Wai.Handler.Warp (run)
import System.FilePath ((<.>), (</>))
import System.IO.Temp (withTempDirectory)

app :: Options -> Application
app Options { buildDir, name, execName } _req respond = respond $ responseFile
  status200
  []
  (buildDir </> name </> execName <.> "jsexe" </> "index.html")
  Nothing

main :: IO ()
main =
  withTempDirectory "." "ghcjsds-build" $ \tempDir -> do
    options <- getOptions tempDir
    chan <- atomically newBroadcastTChan
    void $ forkIO $ runGHCJSWatcher chan options
    void $ forkIO $ run (port (server options)) $ middleware options chan (app options)
    runGHCJSLogger options chan
