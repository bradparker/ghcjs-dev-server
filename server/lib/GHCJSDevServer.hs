module GHCJSDevServer
  ( module GHCJSDevServer.Options
  , module GHCJSDevServer.Server
  , module GHCJSDevServer.Watcher
  , module GHCJSDevServer.Compiler
  , module GHCJSDevServer.Notifier
  , module GHCJSDevServer.Logger
  , middleware
  , runWith
  ) where

import GHCJSDevServer.Compiler
import GHCJSDevServer.Logger
import GHCJSDevServer.Notifier
import GHCJSDevServer.Options
import GHCJSDevServer.Server
import GHCJSDevServer.Watcher

import Control.Concurrent (forkIO)
import Control.Concurrent.STM (TChan, atomically, newBroadcastTChan)
import Control.Monad (void)
import Network.Wai (Application, Middleware)
import Network.Wai.Handler.Warp (run)

middleware :: Options -> TChan (Either String String) -> Middleware
middleware options chan =
  notifierMiddleware chan . serverMiddleware options

runWith :: Options -> Application -> IO ()
runWith options app = do
  chan <- atomically newBroadcastTChan
  void $ forkIO $ runGHCJSWatcher chan options
  run (port (server options)) $ middleware options chan app
