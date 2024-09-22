module Crypto where

import Data.Char

import Prelude hiding (gcd)

{-
The advantage of symmetric encryption schemes like AES is that they are efficient
and we can encrypt data of arbitrary size. The problem is how to share the key.
The flaw of the RSA is that it is slow and we can only encrypt data of size lower
than the RSA modulus n, usually around 1024 bits (64 bits for this exercise!).

We usually encrypt messages with a private encryption scheme like AES-256 with
a symmetric key k. The key k of fixed size 256 bits for example is then exchanged
via the aymmetric RSA.
-}

-------------------------------------------------------------------------------
-- PART 1 : asymmetric encryption

gcd :: Int -> Int -> Int
gcd m n 
 | n == 0    = m
 | otherwise = gcd n (mod m n)  

phi :: Int -> Int
phi m 
 = length [a| a <- [1 .. m], gcd a m == 1 ]   

-- Calculates (u, v, d) the gcd (d) and Bezout coefficients (u and v)
-- such that au + bv = d
computeCoeffs :: Int -> Int -> (Int, Int)
computeCoeffs a b
 | b == 0    = (1, 0)
 | otherwise = ( v', (u' - q * v')) 
  where
   (q, r) = quotRem a b 
   (u', v') = computeCoeffs b r

-- Inverse of a modulo m
-- Pre: gcd(a, m) = 1.
inverse :: Int -> Int -> Int
inverse a m
 = mod u m
  where 
   (u, v) = computeCoeffs a m 

-- Calculates (a^k mod m)
-- Pre: 0 <= a < m.
modPow :: Int -> Int -> Int -> Int
modPow a k m 
 | k == 0    = mod 1 m
 | k == 1    = mod a m 
 | even k    = modPow d (k `div` 2) m
 | otherwise = mod (a * (modPow d ((k - 1) `div` 2) m)) m
  where 
   d = mod (a ^ 2) m 

-- Returns the smallest integer that is coprime with a
-- It iterates over integers >=2 and checks if they are coprime with a. 
smallestCoPrimeOf :: Int -> Int
smallestCoPrimeOf a 
 = smallestCoPrime' 2
  where 
   smallestCoPrime' :: Int -> Int
   smallestCoPrime' b
    | gcd a b == 1 = b
    | otherwise    = smallestCoPrime' (b + 1)

-- Generates keys pairs (public, private) = ((e, n), (d, n))
-- given two "large" distinct primes, p and q
genKeys :: Int -> Int -> ((Int, Int), (Int, Int))
genKeys p q
 = ((e, n), (d, n))
  where
   n = p * q
   e = smallestCoPrimeOf n'
   d = inverse e n'
   n'= (p - 1) * (q - 1)
   
-- RSA encryption/decryption
rsaEncrypt :: Int -> (Int, Int) -> Int
rsaEncrypt x (e, n)
 = modPow x e n  

rsaDecrypt :: Int -> (Int, Int) -> Int
rsaDecrypt x (d, n)
 = modPow x d n

-------------------------------------------------------------------------------
-- PART 2 : symmetric encryption

-- Returns position of a letter in the alphabet
toInt :: Char -> Int
toInt ch 
 = ord ch - ord 'a'

-- Returns the n^th letter
toChar :: Int -> Char
toChar n
 = chr (ord 'a' + n)  

-- "adds" two letters
-- We need to take mod 26 of the resulting sum,
-- in case of the sum being higher than 26 and not a letter 
add :: Char -> Char -> Char
add a b 
 = toChar (mod (toInt a + toInt b) 26)

-- "substracts" two letters
-- We need to take mod 26 of the resulting difference,
-- in case it is higher than 26 and isn't an alphabetic character.
substract :: Char -> Char -> Char
substract a b
 = toChar (mod (toInt a - toInt b) 26)

-- the next functions present
-- 2 modes of operation for block ciphers : ECB and CBC
-- based on a symmetric encryption function e/d such as "add"

-- ecb (electronic codebook) with block size of a letter
--
ecbEncrypt :: Char -> String -> String
ecbEncrypt k s
 = [add m k | m <- s] 

ecbDecrypt :: Char -> String -> String
ecbDecrypt k s
 = [substract m k | m <- s] 
   
-- cbc (cipherblock chaining) encryption with block size of a letter
-- initialisation vector iv is a letter
-- last argument is message m as a string
--
cbcEncrypt :: Char -> Char -> String -> String
cbcEncrypt k iv s
 = [cbc n | n <- [0 .. (length s - 1)]]
  where
   cbc :: Int -> Char
   cbc 0 = ((s !! 0) `add` iv) `add` k
   cbc i = ((s !! i) `add` cbc (i - 1)) `add` k
    
cbcDecrypt :: Char -> Char -> String -> String
cbcDecrypt k iv s
 = [cbc' n | n<- [0 .. (length s - 1)]]
  where 
   cbc' :: Int -> Char
   cbc' 0 = ((s !! 0) `substract` k) `substract` iv 
   cbc' i = ((s !! i) `substract` k) `substract` (s !! (i - 1))
