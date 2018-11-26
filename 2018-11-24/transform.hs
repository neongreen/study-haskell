module Main where

-- Types are inferred up and down
main :: IO ()
main = readLn >>= (print.(*(13::Int)).transform)

-- SPECIALIZE can be used to ensure that there's no performance penalty when
-- calling generic code with a specific type (e.g. Int here)
{-# SPECIALIZE transform :: Int -> Int #-}
transform :: Num a => a -> a
transform n = n * 11

-- the following two are equivalent:

transform2 :: String -> Int
transform2 = read

transform3 :: String -> Int
transform3 s = read s
