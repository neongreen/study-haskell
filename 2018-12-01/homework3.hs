module Homework3 (parse) where

import Data.Char (ord)

data Pair a = Pair a a deriving Show

parse :: String -> Either String (Pair Int)
parse t = do
    (t, r) <- parsePair (parseNumber 0) t
    _ <- eod t
    return r

type Parser a = String -> Either String (String, a)

consume :: (Char -> Either String a) -> Parser a
consume _ "" = Left "unexpected end"
consume f t = do
    case f (head t) of
        Right a -> Right ((tail t), a)
        Left m -> Left m

expect :: Char -> Parser ()
expect c = consume (\x -> if x == c then Right () else Left ("expected '" ++ [c] ++ "', but got '" ++ [x] ++ "'"))

eod :: Parser ()
eod "" = Right ("", ())
eod _ =  Left "tailing characters"

parsePair :: Parser a -> Parser (Pair a)
parsePair f t = do
    (t, _) <- expect '(' t
    (t, a) <- f t
    (t, _) <- expect ',' t
    (t, b) <- f t
    (t, _) <- expect ')' t
    return (t, (Pair a b))

parseNumber :: Int -> Parser Int
parseNumber a t = case parseDigit t of
    Left _ -> Right (t, a)
    Right (t, n) -> parseNumber (a * 10 + n) t

parseDigit :: Parser Int
parseDigit = consume (\c -> if c >= '0' && c <= '9' then Right (ord c - ord '0') else Left("'" ++ [c] ++ "' is not a number"))