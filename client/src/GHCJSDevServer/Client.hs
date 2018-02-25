{-# LANGUAGE OverloadedStrings #-}

module GHCJSDevServer.Client
  ( runGHCJSDevServerClient
  ) where

import           Data.JSString          (JSString, unpack)
import           Data.Monoid            ((<>))
import           GHCJS.Foreign.Callback (Callback, asyncCallback,
                                         asyncCallback1)
import           GHCJS.Marshal          (toJSVal)
import           GHCJS.Types            (JSVal)

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

runGHCJSDevServerClient :: IO ()
runGHCJSDevServerClient = do
  socket <- createWebSocket "ws://localhost:8081" []
  onOpen socket =<< asyncCallback (putStrLn "[GHCJSDS] Connected")
  onClose socket =<< asyncCallback (putStrLn "[GHCJSDS] Disconnected")
  onMessage socket =<<
    asyncCallback1
      (\message -> do
         d <- getData (Message message)
         putStrLn (unpack ("[GHCJSDS] Message " <> d))
         reload)
