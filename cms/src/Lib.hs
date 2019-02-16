{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}


module Lib
    ( main
    ) where

import Servant
import Lucid hiding (toHtmlRaw)
import Servant.HTML.Lucid
import Network.Wai.Handler.Warp as Warp
import qualified Data.Text.IO as TIO
import qualified Data.Text as T
import Data.Text (Text)

import Data.Foldable
import Data.String
import UnliftIO hiding (Handler)
import System.Directory
import System.FilePath
import Control.Monad
import Data.List (isPrefixOf)

import qualified Lucid

main :: IO ()
main = Warp.run 9988 app

app :: Application
app = serve (Proxy @API) api

type API =
    "hello" :> Get '[HTML] (Html ())

api :: Server API
api = helloWorld

helloWorld :: Handler (Html ())
helloWorld = do
    widget :: RawHtml <- liftIO $ readAsset "widget.html"
    pure $ do
        p_ "Widget goes below:"
        toHtml widget

----------------------------------------------------------------------------
-- Raw HTML
----------------------------------------------------------------------------

newtype RawHtml = RawHtml { unRawHtml :: Text }

readAsset :: FilePath -> IO RawHtml
readAsset asset = do
    -- HACKY AND BAD :(
    path <- makeAbsolute ("assets" </> asset)
    assets <- makeAbsolute "assets"
    unless (addTrailingPathSeparator assets `isPrefixOf` path) $
        error "not allowed"
    RawHtml <$> TIO.readFile path

instance ToHtml RawHtml where
    toHtml = Lucid.toHtmlRaw . unRawHtml
    toHtmlRaw = Lucid.toHtmlRaw . unRawHtml
