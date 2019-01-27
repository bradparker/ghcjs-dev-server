{-# OPTIONS_GHC -Wall #-}

module Main
  ( main
  ) where

import qualified Server
import qualified GHCJSDevServer
import qualified Network.Wai.Handler.Warp as Warp

main :: IO ()
main = do
  let options =
        GHCJSDevServer.Options
          { GHCJSDevServer.name = "client"
          , GHCJSDevServer.execName = "client"
          , GHCJSDevServer.sourceDirs =
              ["./client/lib", "./client/dev", "./common/lib"]
          , GHCJSDevServer.buildDir = "./.build"
          , GHCJSDevServer.defaultExts = []
          }
  middleware <- snd <$> GHCJSDevServer.makeMiddleware options
  Warp.run 8080 $ middleware Server.app
