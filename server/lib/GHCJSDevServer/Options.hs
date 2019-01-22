module GHCJSDevServer.Options
  ( Options(..)
  , ServerOptions(..)
  , getOptions
  ) where

import Data.Monoid ((<>))
import Options.Applicative
  ( Parser
  , auto
  , customExecParser
  , fullDesc
  , header
  , help
  , helper
  , info
  , long
  , metavar
  , option
  , prefs
  , short
  , showHelpOnError
  , many
  , str
  , value
  )
import System.Directory (getCurrentDirectory)
import System.FilePath.Posix (takeBaseName)

newtype ServerOptions = ServerOptions
  { port :: Int
  } deriving (Show)

data Options = Options
  { name :: String
  , execName :: String
  , sourceDirs :: [String]
  , buildDir :: String
  , defaultExts :: [String]
  , server :: ServerOptions
  } deriving (Show)

optionsParser :: String -> String -> Parser Options
optionsParser defaultName defaultBuildDir =
  Options <$>
  option
    str
    (value defaultName <> short 'n' <> long "name" <>
     help "Name as it appears in .cabal file" <>
     metavar "NAME") <*>
  option
    str
    (value defaultName <> short 'e' <> long "executable-name" <>
     help "Executable name as it appears in .cabal file" <>
     metavar "EXECUTABLE_NAME") <*>
  many
    (option
       str
       (short 's' <> long "source-dirs" <> help "Source directories" <>
        metavar "SOURCE_DIRECTORIES")) <*>
  option
    str
    (value defaultBuildDir <> short 'b' <> long "build-dir" <>
     help
       "The build dir, where the work is done and static files are served from" <>
     metavar "BUILD_DIR") <*>
  many
    (option
       str
       (short 'x' <> long "default-extensions" <> help "Default GHC extensions" <>
        metavar "DEFAULT_EXTENSIONS")) <*>
  (ServerOptions <$>
   option
     auto
     (value 8080 <> short 'p' <> long "port" <>
      help "A port for the server to listen on" <>
      metavar "PORT"))

getOptions :: String -> IO Options
getOptions defaultBuildDir = do
  defaultName <- takeBaseName <$> getCurrentDirectory
  customExecParser
    (prefs showHelpOnError)
    (info
       (helper <*> optionsParser defaultName defaultBuildDir)
       (header "GHCJS Dev Server - Let's go!" <> fullDesc))
