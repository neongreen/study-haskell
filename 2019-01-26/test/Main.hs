{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}
module Main (main) where

import qualified Lib

import           Test.Hspec
import           Test.Hspec.Wai
import           Test.Hspec.Wai.JSON

import           Network.Wai (Application)
import           Network.Wai.Test (SResponse)
import           Network.HTTP.Types (methodPost, hContentType)

import           Data.ByteString (ByteString)
import qualified Data.ByteString.Lazy as BSL

import UnliftIO



main :: IO ()
main = hspec spec

mkApp :: IO Application
mkApp = do
    storeRef <- newIORef (Lib.RedisStore {Lib.kvs = mempty} :: Lib.RedisStore String String)
    pure (Lib.app storeRef)

spec :: Spec
spec = with mkApp $ do
    describe "GET /:key" $ do
        it "doesn't return nonexistent keys" $ do
            get "/key1" `shouldRespondWith` 404
        it "does return existing keys" $ do
            jpost "/key2" [json|"whatever"|]
            get "/key2" `shouldRespondWith` [json|"whatever"|]

    describe "POST /:key" $ do
        it "overwrites" $ do
            jpost "/key3" [json|"whatever"|]
            jpost "/key3" [json|"whenever"|]
            get "/key3" `shouldRespondWith` [json|"whenever"|]

jpost :: ByteString -> BSL.ByteString -> WaiSession SResponse
jpost path = request methodPost path [(hContentType, "application/json")]
