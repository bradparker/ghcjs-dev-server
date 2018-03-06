module GHCJSDevServer.Notifier
  ( runGHCJSNotifier
  ) where

import           Control.Concurrent.STM (TChan, atomically, dupTChan, readTChan)
import           Control.Monad          (forever)
import           Data.Aeson             (encode)
import           Data.ByteString        (ByteString)
import           Data.ByteString.Char8  (pack)
import           GHCJSDevServer.Options (NotifierOptions (..), Options (..))
import           Network.WebSockets     (ServerApp, acceptRequest, runServer,
                                         sendTextData)

runGHCJSNotifier :: TChan (Either String String) -> Options -> IO ()
runGHCJSNotifier bchan options =
  runServer "0.0.0.0" (_notifierPort (_notifier options)) (app bchan)

app :: TChan (Either String String) -> ServerApp
app bchan conn = do
  accepted <- acceptRequest conn
  chan <- atomically (dupTChan bchan)
  forever $ do
    message <- atomically (readTChan chan)
    sendTextData accepted (encode message)
