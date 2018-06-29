module GHCJSDevServer.Options
  ( Options(..)
  , WatcherOptions(..)
  , ServerOptions(..)
  , NotifierOptions(..)
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

newtype WatcherOptions = WatcherOptions
  { _directory :: String
  } deriving (Show)

newtype ServerOptions = ServerOptions
  { _port :: Int
  } deriving (Show)

newtype NotifierOptions = NotifierOptions
  { _notifierPort :: Int
  } deriving (Show)

data Options = Options
  { _name :: String
  , _execName :: String
  , _sourceDirs :: [String]
  , _buildDir :: String
  , _defaultExts :: [String]
  , _watcher :: WatcherOptions
  , _server :: ServerOptions
  , _notifier :: NotifierOptions
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
  (WatcherOptions <$>
   option
     str
     (value "src" <> short 'w' <> long "watch" <>
      help "The directory to watch for file changes" <>
      metavar "WATCH")) <*>
  (ServerOptions <$>
   option
     auto
     (value 8080 <> short 'p' <> long "port" <>
      help "A port for the server to listen on" <>
      metavar "PORT")) <*>
  (NotifierOptions <$>
   option
     auto
     (value 8081 <> long "notifier-port" <>
      help "A port for the websocket server to listen on" <>
      metavar "NOTIFIER_PORT"))

getOptions :: String -> IO Options
getOptions defaultBuildDir = do
  defaultName <- takeBaseName <$> getCurrentDirectory
  customExecParser
    (prefs showHelpOnError)
    (info
       (helper <*> optionsParser defaultName defaultBuildDir)
       (header "GHCJS Dev Server - Let's go!" <> fullDesc))
