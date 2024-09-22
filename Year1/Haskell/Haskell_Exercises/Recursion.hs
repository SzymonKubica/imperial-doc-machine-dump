power :: Float -> Int -> Float
-- Pre: n >= 0
power x n
 | n == 0 = 1
 | even n = k * k 
 | odd n  = x * k * k
 where
  k = power x (n `div` 2)

add :: Int -> Int -> Int
add a b
 | b == 0    = a
 | otherwise = add (succ a) (pred b)

larger :: Int -> Int -> Int
larger a b
 | a == 0    = b
 | b == 0    = a
 | otherwise = larger (pred a) (pred b) + 1
 
chop :: Int -> (Int, Int)
chop n
 = (quot n,rem n)
 where
  quot :: Int -> Int
  quot n
   | n < 10 = 0
   | otherwise = 1 + quot (n - 10)
  rem :: Int -> Int
  rem n 
   | n < 10 = n
   | otherwise = rem (n - 10)

-- Apparently this version also works and utilises only one recursive function. 
-- It is up to the programmer to decide which is cleaner and more readable.    
chop' :: Int -> (Int, Int)
chop' n
 | n < 10 = (0 , n)
 | otherwise = (1 + fst(chop'(n - 10)), snd(chop'(n - 10)))

--Fibonacci 
fib :: Int -> Int
fib 0 = 1
fib 1 = 1
fib n = fib (n - 1) + fib(n - 2)

-- Fibbonacci more eficiently
-- Function fib2 utilises fib' to compute faster
fib2 :: Int -> Int
fib2 n
 = fib' 1 1 n 
-- kp1 stands for k+1
fib' :: Int -> Int -> Int -> Int
fib' k kp1 n
 | n == 0 = k
 | otherwise = fib' kp1 (k + kp1) (n - 1) 

-- The Golden Ratio
goldenRatio :: Float -> Float
goldenRatio e 
 =  compare 2 2 1 e
  where
   compare :: Int -> Float -> Float -> Float -> Float
-- rn stands for r(n) and rnm1 stands for r(n - 1).
   compare n rn rnm1 e
    | abs(rn - rnm1) < e = rn
    | otherwise = compare (n + 1) (r(n + 1)) rn e
-- Ratio n
r :: Int -> Float
r n 
 = (fromIntegral (fib2 n)) / (fromIntegral (fib2 (n - 1)))
