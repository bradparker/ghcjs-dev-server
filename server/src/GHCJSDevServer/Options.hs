module GHCJSDevServer.Options
  ( Options(..)
  , WatcherOptions(..)
  , ServerOptions(..)
  , getOptions
  ) where

import           Data.Monoid         ((<>))
import           Options.Applicative (Parser, auto, customExecParser,
                                      execParser, fullDesc, header, help,
                                      helper, info, long, metavar, option,
                                      prefs, short, showHelpOnError, str, value)

data WatcherOptions = WatcherOptions
  { _pattern :: String
  } deriving (Show)

data ServerOptions = ServerOptions
  { _port :: Int
  } deriving (Show)

data Options = Options
  { _source    :: String
  , _output    :: String
  , _ghcjsOpts :: String
  , _main      :: String
  , _watcher   :: WatcherOptions
  , _server    :: ServerOptions
  } deriving (Show)

optionsParser :: Parser Options
optionsParser =
  Options <$>
  (option
     str
     (value "src" <> short 'i' <> long "source" <> help "Source directory" <>
      metavar "SOURCE DIRECTORY")) <*>
  (option
     str
     (value "dev-build" <> short 'o' <> long "output" <> help "Build directory" <>
      metavar "BUILD DIRECTORY")) <*>
  (option
     str
     (value "" <> long "ghcjs-opts" <> help "Extra GHCJS flags" <>
      metavar "GHCJS FLAGS")) <*>
  (option
     str
     (value "Main.hs" <> short 'm' <> long "main-is" <> help "Main file." <>
      metavar "MAIN")) <*>
  (WatcherOptions <$>
   option
     str
     (value "**/*.hs" <> short 'w' <> long "watch" <>
      help "A glob pattern for the files we'll watch to trigger re-compilation" <>
      metavar "WATCH")) <*>
  (ServerOptions <$>
   option
     auto
     (value 8080 <> short 'p' <> long "port" <>
      help "A port for the server to listen on" <>
      metavar "PORT"))

getOptions :: IO Options
getOptions =
  customExecParser
    (prefs showHelpOnError)
    (info
       (helper <*> optionsParser)
       (header "GHCJS Dev Server - Let's go!" <> fullDesc))
