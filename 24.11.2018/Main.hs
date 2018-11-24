module Main where

main :: IO ()
main = readLn >>= (print.(*(13::Int)).transform)

{-# SPECIALIZE transform :: Int -> Int #-}
transform :: Num a => a -> a
transform n = n * 11

transformB n = n * 11

transform2 :: String -> Int
transform2 = read

transform3 :: String -> Int
transform3 s = read s