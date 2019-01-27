module Client
  ( main
  ) where

import Common (who)

main :: IO ()
main = putStrLn $ "Hello, " <> who <> "!"
