module Main
  ( main
  ) where

import qualified Client
import GHCJSDevServer.Client (runGHCJSDevServerClient)

main :: IO ()
main = do
  runGHCJSDevServerClient 8080
  Client.main
