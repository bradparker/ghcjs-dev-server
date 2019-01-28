module Main
  ( main
  ) where

import Control.Monad (void)
import GHCJS.DOM (currentDocumentUnchecked)
import GHCJS.DOM.JSFFI.Generated.Document (createElement, getBodyUnchecked)
import GHCJS.DOM.JSFFI.Generated.Element (setInnerHTML)
import GHCJS.DOM.JSFFI.Generated.Node (appendChild)
import GHCJSDevServer.Client (runGHCJSDevServerClient)

app :: IO ()
app = do
  doc <- currentDocumentUnchecked
  elem <- createElement doc "div"
  setInnerHTML elem "Hello, GHCJS!!!"
  body <- getBodyUnchecked doc
  void $ appendChild body elem

main :: IO ()
main = do
  runGHCJSDevServerClient 8080
  app
