module Laziness where
import Debug.Trace

variableName = error "mooo"

main :: IO ()
main = print happylist 

happylist = [1,2,thunk]

thunk :: Int
thunk = trace "just a name, sure" $ 2 + 2

thunk = unsafePerformIO $ do
    print "whatever"
    return (2+2)