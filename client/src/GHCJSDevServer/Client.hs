module GHCJSDevServer.Client
  ( runGHCJSDevServerClient
  ) where

import Control.Monad (join, void)
import Data.Aeson (eitherDecode)
import Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.Lazy.Char8 as ByteString
import Data.Char (isAscii)
import Data.JSString (JSString)
import qualified Data.JSString as JSString
import Data.Monoid ((<>))
import GHCJS.Types (JSVal)
import JavaScript.Web.CloseEvent (CloseEvent)
import JavaScript.Web.Location (getWindowLocation, reload)
import JavaScript.Web.MessageEvent (MessageEvent, MessageEventData(..), getData)
import JavaScript.Web.WebSocket (WebSocket, WebSocketRequest(..), connect)

newtype HTMLElement =
  HTMLElement JSVal

foreign import javascript unsafe
  "$r = document.body"
  getBody :: IO HTMLElement

foreign import javascript unsafe
  "$2.innerHTML = $1; $r = $2"
  setInnerHTML :: JSString -> HTMLElement -> IO HTMLElement

foreign import javascript unsafe
  "$1.appendChild($2); $r = $1"
  appendChild :: HTMLElement -> HTMLElement -> IO HTMLElement

foreign import javascript unsafe
  "document.createElement($1)"
  createElement :: JSString -> IO HTMLElement

decodeMessageData :: JSString -> Either String String
decodeMessageData = join . eitherDecode . ByteString.pack . JSString.unpack

putPrefixed :: String -> String -> IO ()
putPrefixed prefix = putStrLn . (prefix ++)

putGHCJSDS :: String -> IO ()
putGHCJSDS = mapM_ (putPrefixed "[GHCJSDS] ") . lines

errorReport :: String -> IO HTMLElement
errorReport content =
  setInnerHTML (JSString.pack content) =<< createElement "pre"

handleMessage :: MessageEvent -> IO ()
handleMessage event =
  case getData event of
    StringData d ->
      case decodeMessageData d of
        Left err -> do
          putGHCJSDS ("ERROR:\n" ++ tail err)
          body <- setInnerHTML "" =<< getBody
          void (appendChild body =<< errorReport (tail err))
        Right report -> do
          putGHCJSDS ("SUCCESS:\n" ++ report)
          reload True =<< getWindowLocation
    _ -> putGHCJSDS "UNKOWN MESSAGE FORMAT"

handleClose :: CloseEvent -> IO ()
handleClose _ = putGHCJSDS "Disconnected"

runGHCJSDevServerClient :: Int -> IO ()
runGHCJSDevServerClient port = do
  socket <-
    connect
      WebSocketRequest
        { url = "ws://localhost:" <> JSString.pack (show port)
        , protocols = []
        , onClose = Just handleClose
        , onMessage = Just handleMessage
        }
  putGHCJSDS "Waiting for changes ..."
