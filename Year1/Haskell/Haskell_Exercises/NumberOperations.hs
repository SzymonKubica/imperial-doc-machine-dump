--Returns the remainder of a division.
remainder :: Int -> Int -> Int
remainder dividend divisor
 | dividend < divisor = dividend
 | otherwise          = remainder (dividend - divisor) divisor
--Returns quotient of a division.
--Pre: Ignoring division by 0.
quotient :: Int -> Int -> Int
quotient dividend divisor
 | dividend < divisor = 0
 | otherwise          = 1 + quotient (dividend - divisor) divisor

-- Two different ways of computing square roots. 
squareRoot :: Float -> Float
squareRoot x
 = squareRoot' x (x / 2)

squareRoot' :: Float -> Float -> Float
squareRoot' x a 
 | abs (x - a ^ 2) / x < 0.000001 = a -- We need to divide by x to normalise the error, otherwise, for small x it would be inaccurate
 | otherwise = squareRoot' x (( a + x / a) / 2)
-- This function checks whether a number is prime. 
isPrime :: Int -> Bool
isPrime a
 = [x | x <- [2 .. (k)], (mod a x) == 0] == []
  where
  k = floorOfSqrt a
   where 
    floorOfSqrt :: Int -> Int
    floorOfSqrt a 
     = floor ( (sqrt (fromIntegral a :: Float)) :: Float )

-- This recursivec functions add numbers in a recursive way. 
add :: Int -> Int -> Int
add a b
 | b == 0 = a
 | otherwise = add a (b - 1) + 1

-- This is a better version that doest't utilise the stack.
add' :: Int -> Int -> Int
add' a b
 | b == 0 = a
 | otherwise = add' (a + 1) (b - 1)
