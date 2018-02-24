module Main
  ( main
  ) where

import           Data.Monoid ((<>))
import           SomeModule  (who)

main :: IO ()
main = putStrLn ("Hello, " <> who <> "!!!")
