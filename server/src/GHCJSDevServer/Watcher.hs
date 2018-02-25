module GHCJSDevServer.Watcher
  ( runGHCJSWatcher
  ) where

import           Control.Concurrent      (threadDelay)
import           Control.Concurrent.STM  (TChan, atomically, writeTChan)
import           Control.Monad           (forever, void)
import           GHCJSDevServer.Compiler (runGHCJSCompiler)
import           GHCJSDevServer.Options  (Options (..))
import           System.FSNotify         (Event (..), watchDir, withManager)

runGHCJSWatcher :: TChan (Either String String) -> Options -> IO ()
runGHCJSWatcher bchan options = do
  runCompilation bchan options
  withManager
    (\manager -> do
       void
         (watchDir
            manager
            (_source options)
            shouldRecompile
            (const (runCompilation bchan options)))
       forever (threadDelay maxBound))
  where
    shouldRecompile :: Event -> Bool
    shouldRecompile (Modified _ _) = True
    shouldRecompile _              = False

runCompilation :: TChan (Either String String) -> Options -> IO ()
runCompilation bchan options = do
  res <- runGHCJSCompiler options
  atomically (writeTChan bchan res)