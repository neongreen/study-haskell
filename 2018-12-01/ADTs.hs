{-# LANGUAGE NamedFieldPuns #-}  -- Enables bringing record fields into scope 
                                 -- with Record{a, b} instead of Record{a=a, b=b}

module ADTs where

import Text.Read (readEither)   -- Good practice to import explicitly

data Point = Cartesian {x :: Double, y :: Double}
           | Polar {r :: Double, theta :: Double}
           deriving Show

-- | Calculate the distance from the origin to a 2D point.
distance :: Point -> Double
distance Cartesian{x, y} = sqrt (x*x + y*y)
distance Polar{r} = r  -- Note: here we are ignoring 'theta'.

-- | A custom error type used in the following functions.
--
-- In production code it would likely have a more descriptive name.
-- Alternatively, the module could have been designed to be imported
-- qualified and then users of our module would refer to it
-- as "ADTs.Error".
data Error = NotIntParseable {message :: String, value :: String}
           | OtherBadStuff {message :: String}
           deriving Show

-- | Parse two integers and fail if either is unparseable.
--
-- This variant uses an explicit case match. It will get cumbersome
-- once we have more than two arguments.
readNumbers_case :: String -> String -> Either Error (Int, Int)
readNumbers_case x y = case (readNumber x, readNumber y) of
  (Left a, _)          -> Left a 
  (_, Left b)          -> Left b
  (Right x', Right y') -> Right (x', y')

-- | Same as the previous function, but uses do notation.
readNumbers_do :: String -> String -> Either Error (Int, Int)
readNumbers_do x y = do
  x' <- readNumber x
  y' <- readNumber y
  return (x', y')          -- Alternatively: Right (x', y')

-- Desugared:
--
--     readNumbers2 x y =
--       readNumber x >>= \x' ->
--       readNumber y >>= \y' ->
--       Right (x', y')

-- | A helper function that parses just one integer.
readNumber :: String -> Either Error Int
readNumber x = case readEither x of
  Left _   -> Left NotIntParseable {message = "Bad " ++ show x, value = show x}
  Right x' -> Right x'

-- Note: 'do' is not just for monads. The 'Monad' constraint is incurred by
-- the desugaring of '<-', but if we don't use it, no 'Monad' is required.
-- The following expressions are equivalent:

four = do
  let a = 2
  let b = 2
  a + b
  
four' = let a = 2 in let b = 2 in a + b
