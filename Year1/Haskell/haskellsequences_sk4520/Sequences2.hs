module Sequences2 where

import Data.Char (ord, chr)

-- Returns the first argument if it is larger than the second,
-- the second argument otherwise
maxOf2 :: Int -> Int -> Int
maxOf2 x y
  | x > y     = x 
  | otherwise = y

-- Returns the largest of three Ints
maxOf3 :: Int -> Int -> Int -> Int
maxOf3 x y z
  | x >= y && x >= z = x  
  | y >= x && y >= z = y  
  | z >= x && z >= y = z  

-- Returns True if the character represents a digit '0'..'9';
-- False otherwise
isADigit :: Char -> Bool
isADigit ch
  = ord ch >= 48 && ord ch <= 57

-- Returns True if the character represents an alphabetic
-- character either in the range 'a'..'z' or in the range 'A'..'Z';
-- False otherwise
-- Checks whether a character fits with its ASCII number into one of the two intervals, 
-- Namely [65,90] which represents uppercase and [97,122] which represents lowercase characters
isAlpha :: Char -> Bool
isAlpha ch
  = ord ch >= 65 && ord ch <= 90 || ord ch >= 97 && ord ch <= 122 

-- Returns the integer [0..9] corresponding to the given character.
-- Note: this is a simpler version of digitToInt in module Data.Char,
-- which does not assume the precondition.
digitToInt :: Char -> Int
-- Pre: the character is one of '0'..'9'
digitToInt ch
  = ord ch - 48

-- Returns the upper case character corresponding to the input.
-- Uses guards by way of variety.
-- Returns a character that has an ASCII ordinal number 32 less than the input character.
-- If the character is already uppercase, it leaves it unchanged.
toUpper :: Char -> Char
toUpper  ch
 | ord ch >= 65 && ord ch <= 90 = ch
 | otherwise                    = chr( ord ch - 32)

--
-- Sequences and series
--

-- Arithmetic sequence
arithmeticSeq :: Double -> Double -> Int -> Double
arithmeticSeq a d n
  = a + (fromIntegral n) * d

-- Geometric sequence
geometricSeq :: Double -> Double -> Int -> Double
geometricSeq a r n
  = a * r ^ (fromIntegral n)

-- Arithmetic series
arithmeticSeries :: Double -> Double -> Int -> Double
arithmeticSeries a d n
  = (k + 1) * (a + d * k / 2)
    where 
     k = fromIntegral n

-- Geometric series
geometricSeries :: Double -> Double -> Int -> Double
geometricSeries a r n 
 | r == 1    = a * (fromIntegral (n + 1))
 | otherwise = a * ( (1 - r ^ ((fromIntegral n) + 1)) / (1 - r))

