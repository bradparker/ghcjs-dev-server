module GHCJSDevServer.Logger
  ( logger
  ) where

import System.Console.ANSI
  ( Color(Blue, Green, Red, White)
  , ColorIntensity(Dull, Vivid)
  , ConsoleLayer(Background, Foreground)
  , SGR(Reset, SetColor)
  , clearScreen
  , setCursorPosition
  , setSGR
  )

logger :: Int -> Either String String -> IO ()
logger port message = do
  setCursorPosition 0 0
  clearScreen
  setSGR [SetColor Foreground Vivid White, SetColor Background Dull Blue]
  putStrLn "GHCJS"
  setSGR [Reset]
  setSGR [SetColor Foreground Dull Blue]
  putStrLn ("Server listening on: " ++ show port)
  setSGR [Reset]
  case message of
    Left err -> do
      setSGR [SetColor Foreground Vivid White, SetColor Background Dull Red]
      putStrLn "ERROR"
      setSGR [Reset]
      setSGR [SetColor Foreground Dull Red]
      putStrLn (dropWhile (== '\n') err)
      setSGR [Reset]
    Right result -> do
      setSGR [SetColor Foreground Vivid White, SetColor Background Dull Green]
      putStrLn "SUCCESS"
      setSGR [Reset]
      setSGR [SetColor Foreground Dull Green]
      putStrLn result
      setSGR [Reset]
