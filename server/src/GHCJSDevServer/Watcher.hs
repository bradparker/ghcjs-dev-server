module GHCJSDevServer.Watcher
  ( runGHCJSWatcher
  ) where

import Control.Concurrent (threadDelay)
import Control.Concurrent.STM (TChan, atomically, writeTChan)
import Control.Monad (forever)
import GHCJSDevServer.Compiler (runGHCJSCompiler)
import GHCJSDevServer.Options (Options(..))
import System.FSNotify (Event(..), watchDir, withManager)
import Data.Foldable (for_)

runGHCJSWatcher :: TChan (Either String String) -> Options -> IO ()
runGHCJSWatcher chan options = do
  runCompilation chan options
  withManager $ \manager -> do
    for_ (sourceDirs options) $ \dir ->
      watchDir manager dir shouldRecompile (const (runCompilation chan options))
    forever (threadDelay maxBound)
 where
  shouldRecompile :: Event -> Bool
  shouldRecompile Modified{} = True
  shouldRecompile _          = False

runCompilation :: TChan (Either String String) -> Options -> IO ()
runCompilation chan options = do
  res <- runGHCJSCompiler options
  atomically (writeTChan chan res)
