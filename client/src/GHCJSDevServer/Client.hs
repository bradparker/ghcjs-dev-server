{-# LANGUAGE OverloadedStrings #-}

module GHCJSDevServer.Client
  ( runGHCJSDevServerClient
  ) where

import           Control.Monad              (join)
import           Data.Aeson                 (eitherDecode)
import           Data.ByteString.Lazy       (ByteString)
import           Data.ByteString.Lazy.Char8 (pack)
import           Data.JSString              (JSString, unpack)
import qualified Data.JSString              as JString
import           Data.Monoid                ((<>))
import           GHCJS.Foreign.Callback     (Callback, asyncCallback,
                                             asyncCallback1)
import           GHCJS.Marshal              (toJSVal)
import           GHCJS.Types                (JSVal)

newtype WebSocket =
  WebSocket JSVal

foreign import javascript unsafe "$r = new WebSocket($1, $2);"
               js_createWebSocket :: JSString -> JSVal -> IO WebSocket

createWebSocket :: JSString -> [JSString] -> IO WebSocket
createWebSocket url protocols = js_createWebSocket url =<< toJSVal protocols

foreign import javascript unsafe "$1.addEventListener('open', $2)"
               onOpen :: WebSocket -> Callback (IO ()) -> IO ()

foreign import javascript unsafe "$1.addEventListener('close', $2)"
               onClose :: WebSocket -> Callback (IO ()) -> IO ()

foreign import javascript unsafe
               "$1.addEventListener('message', $2)" onMessage ::
               WebSocket -> Callback (JSVal -> IO ()) -> IO ()

foreign import javascript unsafe "$1.data" getData ::
               Message -> IO JSString

foreign import javascript unsafe "location.reload(true)" reload ::
               IO ()

newtype Message =
  Message JSVal

decodeMessageData :: JSString -> Either String String
decodeMessageData = join . eitherDecode . pack . unpack

putPrefixed :: String -> String -> IO ()
putPrefixed prefix = putStrLn . (prefix ++)

putGHCJSDS :: String -> IO ()
putGHCJSDS = mapM_ (putPrefixed "[GHCJSDS] ") . lines

runGHCJSDevServerClient :: Int -> IO ()
runGHCJSDevServerClient port = do
  socket <- createWebSocket ("ws://localhost:" <> JString.pack (show port)) []
  onOpen socket =<< asyncCallback (putStrLn "[GHCJSDS] Connected")
  onClose socket =<< asyncCallback (putStrLn "[GHCJSDS] Disconnected")
  onMessage socket =<<
    asyncCallback1
      (\message -> do
         result <- decodeMessageData <$> getData (Message message)
         case result of
           Left err     -> putGHCJSDS ("ERROR:" ++ err)
           Right report -> putGHCJSDS ("SUCCESS:\n" ++ report) *> reload)
