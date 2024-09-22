-- Pre a >= 0
fact :: Int -> Int
fact a
 | a == 0    = 1
 | otherwise = a * fact (a - 1)

-- Pre: n >= r.
-- That is because we cannot select more elements from a set than there are in the set.
perm :: Int -> Int -> Int 
perm n r 
 | r == 0 = 1
 | otherwise = n * perm (n - 1) (r - 1)

-- Pre: n >= r.
-- The first function computes a float value and the second returns an int.

choose :: Int -> Int -> Int
choose n r
 = (floor(computeAnswer n r)) :: Int
 where
  computeAnswer :: Int -> Int -> Float
  computeAnswer n r
   | n == r = 1
   | otherwise = (( k / (k - p)) * computeAnswer (n - 1) r)  
    where 
     k = fromIntegral n :: Float
     p = fromIntegral r :: Float 
