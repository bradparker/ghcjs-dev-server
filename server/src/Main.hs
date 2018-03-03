module Main
  ( main
  ) where

import           Control.Concurrent     (forkIO)
import           Control.Concurrent.STM (atomically, newBroadcastTChan)
import           Control.Monad          (void)
import           GHCJSDevServer         (getOptions, runGHCJSLogger,
                                         runGHCJSNotifier, runGHCJSServer,
                                         runGHCJSWatcher)

main :: IO ()
main = do
  options <- getOptions
  bchan <- atomically newBroadcastTChan
  void (forkIO (runGHCJSWatcher bchan options))
  void (forkIO (runGHCJSNotifier bchan options))
  void (forkIO (runGHCJSServer options))
  runGHCJSLogger options bchan
