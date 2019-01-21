module GHCJSDevServer.Server
  ( serverMiddleware
  ) where

import GHCJSDevServer.Options (Options(..))
import Network.Wai (Middleware)
import Network.Wai.Middleware.Static (addBase, staticPolicy)
import System.FilePath ((<.>), (</>))

serverMiddleware :: Options -> Middleware
serverMiddleware Options {name, buildDir, execName} =
  staticPolicy (addBase (buildDir </> name </> execName <.> "jsexe"))
