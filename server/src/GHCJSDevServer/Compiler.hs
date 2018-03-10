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
args Options {_name, _execName, _sourceDirs, _buildDir, _defaultExts} =
  map ("-i" <>) _sourceDirs ++
  map ("-X" <>) _defaultExts ++
  [ "-outputdir"
  , _buildDir </> _name
  , "-o"
  , _buildDir </> _name </> _execName
  , "Main"
  ]

runGHCJSCompiler :: Options -> IO (Either String String)
runGHCJSCompiler options@Options {_buildDir, _name, _execName} = do
  createDirectoryIfMissing True (_buildDir </> _name </> _execName)
  (code, out, err) <- readProcessWithExitCode "ghcjs" (args options) ""
  case code of
    ExitSuccess   -> return (Right out)
    ExitFailure _ -> return (Left err)
