module Main
  ( main
  ) where

import           Control.Concurrent     (forkIO)
import           Control.Concurrent.STM (atomically, dupTChan,
                                         newBroadcastTChan, readTChan)
import           Control.Monad          (forever)
import           GHCJSDevServer         (Options (..), ServerOptions (..),
                                         getOptions, runGHCJSNotifier,
                                         runGHCJSServer, runGHCJSWatcher)

main :: IO ()
main = do
  options <- getOptions
  bchan <- atomically newBroadcastTChan
  forkIO (runGHCJSWatcher bchan options)
  forkIO (runGHCJSNotifier bchan options)
  forkIO (runGHCJSServer options)
  putStrLn ("Server listening on: " ++ show (_port (_server options)))
  chan <- atomically $ dupTChan bchan
  forever $ do
    message <- atomically $ readTChan chan
    print message
