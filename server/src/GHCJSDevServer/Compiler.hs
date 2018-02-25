{-# LANGUAGE NamedFieldPuns #-}

module GHCJSDevServer.Compiler
  ( runGHCJSCompiler
  ) where

import           Data.Monoid            ((<>))
import           GHCJSDevServer.Options (Options (..))
import           System.Directory       (createDirectoryIfMissing)
import           System.Exit            (ExitCode (..))
import           System.FilePath        ((</>))
import           System.Process         (readProcessWithExitCode)

args :: Options -> [String]
args Options {_source, _output, _main, _ghcjsOpts} =
  [ ("-i" <> _source)
  , "-o"
  , _output </> "app"
  , "-hidir"
  , _output
  , "-odir"
  , _output
  , (_source </> _main)
  ] ++
  (words _ghcjsOpts)

runGHCJSCompiler :: Options -> IO (Either String String)
runGHCJSCompiler options = do
  createDirectoryIfMissing True (_output options)
  (code, out, err) <- (readProcessWithExitCode "ghcjs" (args options) "")
  case code of
    ExitSuccess   -> return (Right out)
    ExitFailure _ -> return (Left err)
