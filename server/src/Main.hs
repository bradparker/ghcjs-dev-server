module Main
  ( main
  ) where

import           Control.Concurrent     (forkIO)
import           Control.Concurrent.STM (atomically, newBroadcastTChan)
import           GHCJSDevServer         (Options (..), getOptions,
                                         runGHCJSNotifier, runGHCJSServer,
                                         runGHCJSWatcher)

main :: IO ()
main = do
  options <- getOptions
  bchan <- atomically newBroadcastTChan
  forkIO (runGHCJSWatcher bchan options)
  forkIO (runGHCJSNotifier bchan options)
  runGHCJSServer options
