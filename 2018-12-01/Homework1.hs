module Homework1 where

maybe :: b -> (a -> b) -> Maybe a -> b
maybe b _ Nothing = b
maybe _ f (Just a) = f a

either :: (a -> c) -> (b -> c) -> Either a b -> c
either f _ (Left a) = f a
either _ f (Right b) = f b

bindMaybe :: Maybe a -> (a -> Maybe b) -> Maybe b
bindMaybe Nothing _ = Nothing
bindMaybe (Just a) f = f a

returnMaybe :: a -> Maybe a
returnMaybe = Just

bindEither :: Either x a -> (a -> Either x b) -> Either x b
bindEither (Left x) _ = Left x
bindEither (Right a) f = f a

returnEither :: a -> Either x a
returnEither = Right

showEither :: (Show a, Show b) => Either a b -> String
showEither (Left a) = "Left " ++ show a
showEither (Right b) = "Right " ++ show b