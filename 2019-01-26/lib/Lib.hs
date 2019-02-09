{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

module Lib where

import UnliftIO hiding (Handler)

import Control.Monad (forever)
import Data.Foldable (forM_)
import qualified Data.HashMap.Strict as HM
import Data.Hashable
import qualified Data.List as List
import Control.Exception (throwIO)
import Network.Wai.Handler.Warp as Warp

import Servant
import Servant.Server

-- GET /:key
-- POST /:key   // reqbody = string

----------------------------------------------------------------------------
-- Main
----------------------------------------------------------------------------

main :: IO ()
main = do
  hSetBuffering stdin LineBuffering
  putStrLn "foobar"
  storeRef <-
    newIORef (RedisStore {kvs = HM.fromList [("hi", "haskell")]} :: RedisStore String String)
  Warp.run 8877 (app storeRef)
  -- forever $ storeAction storeRef
  return ()

app :: IORef (RedisStore String String) -> Application
app storeRef = serve (Proxy @API) (api storeRef)


----------------------------------------------------------------------------
-- API
----------------------------------------------------------------------------

type API =
    Capture "key" String :>
      Get '[JSON] String
    :<|>
    Capture "key" String :>
      ReqBody '[JSON] String :>
      Post '[JSON] NoContent

api :: IORef (RedisStore String String) -> Server API
api storeRef =
    getValueHandler storeRef :<|>
    putValueHandler storeRef

----------------------------------------------------------------------------
-- Handlers
----------------------------------------------------------------------------

getValueHandler
    :: IORef (RedisStore String String)
    -> String
    -> Handler String
getValueHandler storeRef key = do
    store <- liftIO $ readIORef storeRef
    let (mbValue, store') = cmdRunner (Get key) store
    writeIORef storeRef store'
    case mbValue of
        Nothing -> throwError err404 {
            errBody = "key not found"
        }
        Just value -> pure value

putValueHandler
    :: IORef (RedisStore String String)
    -> String
    -> String
    -> Handler NoContent
putValueHandler storeRef key value = do
    store <- liftIO $ readIORef storeRef
    let (_, store') = cmdRunner (Set key value) store
    writeIORef storeRef store'
    pure NoContent

----------------------------------------------------------------------------
-- Various other stuff
----------------------------------------------------------------------------


storeAction :: IORef (RedisStore String String) -> IO ()
storeAction storeRef = do
  putStrLn "Please! Give input"
  input :: Command String String <- readLn
  putStrLn $ "Your input: " ++ show input
  (maybeValue, store') <-
    atomicModifyIORef'
      storeRef
      (\store ->
         let (maybeValue, store') = cmdRunner input store
          in (store', (maybeValue, store')))
  forM_ maybeValue (\value -> putStrLn $ "Requested value: " ++ show value)
  putStrLn $ "New store: " ++ show store'
  return ()

data Command key value
  = Get { key :: key }
  | Set { key :: key
        , value :: value }
  deriving (Show, Read)

data RedisStore key value = RedisStore
  { kvs :: HM.HashMap key value
  } deriving (Show)

getValue :: (Eq key, Hashable key) => key -> RedisStore key value -> Maybe value
getValue key RedisStore {kvs} = HM.lookup key kvs

setValue ::
     (Eq key, Hashable key)
  => key
  -> value
  -> RedisStore key value
  -> RedisStore key value
setValue key value (RedisStore {kvs}) =
  RedisStore {kvs = HM.insert key value kvs}

cmdRunner ::
     (Eq key, Hashable key)
  => Command key value
  -> RedisStore key value
  -> (Maybe value, RedisStore key value)
cmdRunner Get {key} store = (getValue key store, store)
cmdRunner Set {key, value} store = (Nothing, setValue key value store)


-- links
-- unliftio
-- http://hackage.haskell.org/package/rebase
-- https://monadfix.io/#2018-10-15-servant-mocking
