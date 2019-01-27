{-# LANGUAGE OverloadedStrings #-}

module Client
  ( main
  ) where

import Common (who)
import Control.Monad (void)
import Data.JSString (JSString)
import qualified Data.JSString as JSString
import GHCJS.Types (JSVal)

newtype HTMLElement =
  HTMLElement JSVal

foreign import javascript unsafe
  "$r = document.getElementById($1)"
  getElementById :: JSString -> IO HTMLElement

foreign import javascript unsafe
  "$2.innerHTML = $1; $r = $2"
  setInnerHTML :: JSString -> HTMLElement -> IO HTMLElement

greeting :: JSString
greeting =
  "Hello, " <> JSString.pack who <> "! From, GHCJS!"

main :: IO ()
main = do
  appElem <- getElementById "app"
  void $ setInnerHTML greeting appElem
