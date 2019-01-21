module GHCJSDevServer.Notifier
  ( notifierMiddleware
  , notifierApp
  ) where

import Control.Concurrent.STM (TChan, atomically, dupTChan, readTChan)
import Control.Monad (forever)
import Data.Aeson (encode)
import Data.Bifunctor (bimap)
import Data.Char (isAscii)
import Network.Wai (Middleware)
import Network.Wai.Handler.WebSockets (websocketsOr)
import Network.WebSockets
  ( ServerApp
  , acceptRequest
  , defaultConnectionOptions
  , sendTextData
  )

notifierMiddleware :: TChan (Either String String) -> Middleware
notifierMiddleware = websocketsOr defaultConnectionOptions . notifierApp

notifierApp :: TChan (Either String String) -> ServerApp
notifierApp bchan conn = do
  accepted <- acceptRequest conn
  chan <- atomically (dupTChan bchan)
  forever $ do
    message <- atomically (readTChan chan)
    sendTextData accepted (encode (bimap asciiOnly asciiOnly message))
  where
    asciiOnly = filter isAscii
