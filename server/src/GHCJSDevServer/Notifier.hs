module GHCJSDevServer.Notifier
  ( runGHCJSNotifier
  ) where

import           Control.Concurrent.STM (TChan, atomically, dupTChan, readTChan)
import           Control.Monad          (forever)
import           Data.ByteString        (ByteString)
import           Data.ByteString.Char8  (pack)
import           GHCJSDevServer.Options (Options (..))
import           Network.WebSockets     (ServerApp, acceptRequest, runServer,
                                         sendTextData)

runGHCJSNotifier :: TChan (Either String String) -> Options -> IO ()
runGHCJSNotifier bchan options = runServer "0.0.0.0" 8081 (app bchan)

app :: TChan (Either String String) -> ServerApp
app bchan conn = do
  accepted <- acceptRequest conn
  chan <- atomically (dupTChan bchan)
  forever $ do
    message <- atomically (readTChan chan)
    sendTextData accepted (pack (show message))
