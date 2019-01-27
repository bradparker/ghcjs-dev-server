module GHCJSDevServer
  ( module GHCJSDevServer.Options
  , module GHCJSDevServer.Server
  , module GHCJSDevServer.Watcher
  , module GHCJSDevServer.Compiler
  , module GHCJSDevServer.Notifier
  , module GHCJSDevServer.Logger
  , makeMiddleware
  , middleware
  , outputDirectory
  ) where

import GHCJSDevServer.Compiler
import GHCJSDevServer.Logger
import GHCJSDevServer.Notifier
import GHCJSDevServer.Options
import GHCJSDevServer.Server
import GHCJSDevServer.Watcher

import Control.Concurrent (forkIO)
import Control.Concurrent.STM (TChan, atomically, newBroadcastTChan)
import Data.Functor (void)
import Network.Wai (Middleware)
import System.FilePath ((<.>), (</>))

middleware
  :: Options
  -> TChan (Either String String)
  -> Middleware
middleware options chan =
  notifierMiddleware chan . serverMiddleware options

makeMiddleware
  :: Options
  -> IO (TChan (Either String String), Middleware)
makeMiddleware opts = do
  chan <- atomically newBroadcastTChan
  void $ forkIO $ runGHCJSWatcher chan opts
  pure (chan, middleware opts chan)

outputDirectory :: Options -> String
outputDirectory Options {buildDir, name, execName} =
  buildDir </> name </> execName <.> "jsexe"
