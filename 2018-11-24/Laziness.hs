module Laziness where

import Debug.Trace

main :: IO ()
main = print sadlist

-- This is a value that throws an exception when evaluated
bad = error "mooo"

-- When printing this list, "1" and "2" will be printed but then an error
-- will be thrown
sadlist = [1,2,bad]

-- "just a name, sure" will be printed when evaluating this value, but only
-- once; then the value "result" will be stored in memory and no code will
-- be executed when evaluating it
thunk :: Int
thunk = trace "just a name, sure" $ 2 + 2

{- an alternative way of implementing 'thunk'

thunk = unsafePerformIO $ do
    putStrLn "whatever"
    return (2+2)
-}
