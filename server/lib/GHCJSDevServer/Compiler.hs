module GHCJSDevServer.Compiler
  ( runGHCJSCompiler
  ) where

import Data.Monoid ((<>))
import GHCJSDevServer.Options (Options(..))
import System.Directory (createDirectoryIfMissing)
import System.Exit (ExitCode(..))
import System.FilePath ((</>))
import System.Process (readProcessWithExitCode)

args :: Options -> [String]
args Options {name, execName, sourceDirs, buildDir, defaultExts} =
  map ("-i" <>) sourceDirs ++
  map ("-X" <>) defaultExts ++
  [ "-outputdir"
  , buildDir </> name
  , "-o"
  , buildDir </> name </> execName
  , "Main"
  ]

runGHCJSCompiler :: Options -> IO (Either String String)
runGHCJSCompiler options@Options {buildDir, name, execName} = do
  createDirectoryIfMissing True (buildDir </> name </> execName)
  (code, out, err) <- readProcessWithExitCode "ghcjs" (args options) ""
  case code of
    ExitSuccess -> return (Right out)
    ExitFailure _ -> return (Left err)
