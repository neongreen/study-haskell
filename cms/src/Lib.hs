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
import Lucid
import Servant.HTML.Lucid
import Network.Wai.Handler.Warp as Warp

main :: IO ()
main = Warp.run 9988 app

app :: Application
app = serve (Proxy @API) api

type API =
    "hello" :> Get '[HTML] (Html ())

api :: Server API
api = helloWorld

helloWorld :: Handler (Html ())
helloWorld = pure $
    p_ "hello world!"
