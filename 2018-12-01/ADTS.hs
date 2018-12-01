{-# LANGUAGE NamedFieldPuns #-}  -- Enables accessing records with {}

module ADTS where

import Text.Read (readEither)   -- Good practice to import explicitly

data Point = Cartesian {x :: Double, y :: Double}
           | Polar {r :: Double, theta :: Double}
           deriving Show

distance :: Point -> Double
distance Cartesian{x, y} = sqrt (x*x + y*y)
distance Polar{r} = r

-- Is 'Error' a good name?
data Error = NotIntParseable {message :: String, value :: String}
           | OtherBadStuff {message :: String}
           deriving Show

readNumbers :: String -> String -> Either Error (Int, Int)
readNumbers x y = case (readNumber x, readNumber y) of
  (Left a, _)          -> Left a 
  (_, Left b)          -> Left b
  (Right x', Right y') -> Right (x', y')

readNumbers2 :: String -> String -> Either Error (Int, Int)
readNumbers2 x y = do
  x' <- readNumber x
  y' <- readNumber y
  return (x', y')          -- Alternatively: Right (x', y')
-- De-sugared 'do':
-- readNumbers2 x y =
--   readNumber x >>= \x' ->
--   readNumber y >>= \y' -> Right (x', y')

readNumber :: String -> Either Error Int
readNumber x = case readEither x of
  Left _   -> Left NotIntParseable {message = "Bad " ++ show x, value = show x}
  Right x' -> Right x'

-- 'do' is not just for monads:
four = do
  let a = 2
  let b = 2
  a + b
  
-- Equivalently:
four' = let a = 2 in let b = 2 in a + b
