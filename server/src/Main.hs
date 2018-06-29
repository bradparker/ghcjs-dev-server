module Main
  ( main
  ) where

import Control.Concurrent (forkIO)
import Control.Concurrent.STM (atomically, newBroadcastTChan)
import Control.Monad (void)
import GHCJSDevServer
  ( getOptions
  , runGHCJSLogger
  , runGHCJSNotifier
  , runGHCJSServer
  , runGHCJSWatcher
  )
import System.IO.Temp (withTempDirectory)

main :: IO ()
main =
  withTempDirectory "." "ghcjsds-build" $ \tempDir -> do
    options <- getOptions tempDir
    bchan <- atomically newBroadcastTChan
    void (forkIO (runGHCJSWatcher bchan options))
    void (forkIO (runGHCJSNotifier bchan options))
    void (forkIO (runGHCJSServer options))
    runGHCJSLogger options bchan
