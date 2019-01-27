{-# LANGUAGE OverloadedStrings #-}

module Server
  ( app
  ) where

import Common (who)
import Data.ByteString.Lazy.Char8 as LBS
import Network.HTTP.Types (status200)
import Network.Wai (Application, responseLBS)

app :: Application
app req respond =
  respond $ responseLBS status200 [] $ mconcat
    [ "<!DOCTYPE html>"
    , "<html>"
    , "<head>"
    , " <meta charset=\"utf8\">"
    , " <script language=\"javascript\" src=\"/rts.js\"></script>"
    , " <script language=\"javascript\" src=\"/lib.js\"></script>"
    , " <script language=\"javascript\" src=\"/out.js\"></script>"
    , "</head>"
    , "<body>"
    , " <main id=\"app\">Hello, " <> LBS.pack who <> "!!!</main>"
    , " <script language=\"javascript\" src=\"/runmain.js\" defer></script>"
    , "</body>"
    , "</html>"
    ]
