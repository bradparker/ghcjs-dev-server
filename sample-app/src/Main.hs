module Main
  ( main
  ) where

import Data.Monoid ((<>))
import GHCJSDevServer.Client (runGHCJSDevServerClient)
import SomeModule (who)

main :: IO ()
main = runGHCJSDevServerClient 8081 *> putStrLn ("Hello, " <> who <> "!")
