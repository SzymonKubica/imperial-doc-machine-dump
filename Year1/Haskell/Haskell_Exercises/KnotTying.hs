fibTail :: Integer -> Integer
fibTail n = fibTail' n 1 1
  where
    fibTail' :: Integer -> Integer -> Integer -> Integer
    fibTail' 0 f1 f2 = f1
    fibTail' n f1 f2 = fibTail' (n - 1) f2 (f1 + f2)

fibTable :: [Integer]
fibTable = [fib' n | n <- [0..]]

fib' :: Integer -> Integer
fib' 0 = 1
fib' 1 = 1
fib' n = (fibTable !! (fromIntegral (n - 1)) + (fibTable !! (fromIntegral (n - 2))))

ones :: [Integer] 
ones = 1 : ones

nums :: [Integer]
nums = 1 : map succ nums

fibs :: [Integer]
fibs = 1 : 1 : zipWith (+) fibs (tail fibs)

fib'' :: (Integer -> Integer) -> Integer -> Integer
fib'' k 0 = 1
fib'' k 1 = 1
fib'' k n = (n - 1) + k (n - 2)

fibOrig :: Integer -> Integer
fibOrig n = fib'' fibOrig n



