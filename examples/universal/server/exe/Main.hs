module Main
  ( main
  ) where

import qualified Server
import qualified Network.Wai.Handler.Warp as Warp

main :: IO ()
main = Warp.run 8080 Server.app
