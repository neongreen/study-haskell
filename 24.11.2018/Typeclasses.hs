{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE DefaultSignatures #-}
module Typeclasses where

class Eq a => Favorite a where
    isFavorite :: a -> Bool
    -- default isFavorite :: Eq a => a -> Bool
    isFavorite = (==) favorite
    favorite :: a

instance Favorite Int where
    isFavorite 0 = True
    isFavorite _ = False

    favorite = 0

instance Favorite String where
    isFavorite x = True
    isFavorite _ = False

    favorite = "favorite"