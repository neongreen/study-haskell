#!/usr/bin/env stack
-- stack --resolver lts-13.5 --install-ghc runghc --package unordered-containers
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Control.Monad (forever)
import Data.Foldable (forM_)
import qualified Data.HashMap.Strict as HM
import Data.Hashable
import Data.IORef
import qualified Data.List as List
import Lib
import System.IO

main :: IO ()
main = do
  hSetBuffering stdin LineBuffering
  putStrLn "foobar"
  storeRef <-
    newIORef (RedisStore {kvs = HM.fromList []} :: RedisStore String String)
  forever $ storeAction storeRef
  return ()

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
