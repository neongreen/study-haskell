{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
-- {-# LANGUAGE DefaultSignatures #-}

module Typeclasses where

class Eq a => Favorite a where
    isFavorite :: a -> Bool

    -- Or with DefaultSignatures (which lets us avoid the Eq a constraint on
    -- the typeclass itself):
    --
    -- default isFavorite :: Eq a => a -> Bool
    isFavorite = (==) favorite

    favorite :: a

instance Favorite Int where
    favorite = 0

instance Favorite String where
    isFavorite favorite = True  -- broken!
    isFavorite _ = False

    favorite = "favorite"
