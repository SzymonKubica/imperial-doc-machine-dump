import Data.List

primeFactors :: Int -> [Int]
primeFactors n
  = check n 2
    where
      check :: Int -> Int -> [Int]
      check n m 
        | n == 1    = []
        | r == 0    = m : check q m
        | otherwise = check n (m + 1) 
          where 
            (q, r) = quotRem n m

hcf' :: Int -> Int -> Int
hcf' a b 
  = product (pa \\ (pa \\ pb)) 
    where
      pa = primeFactors a
      pb = primeFactors b

lcm' :: Int -> Int -> Int
lcm' a b
  | a >= b = a * product (pb \\ pa)
  | b >= a = b * product (pa \\ pb)
    where
      pa = primeFactors a
      pb = primeFactors b

foldlx f u [] 
  = u
foldlx f u (x : xs)
 = foldlx f (f u x) xs
      

findAll x [] 
  = []
findAll x (t : ts)
  | x == y       = z : findAll x ts
  | otherwise    = findAll x ts
    where
      (y, z) = t

remove :: Eq a => a -> [(a,b)] -> [(a,b)]
remove x [] 
  = []
remove x (t : ts)
  | x == y = remove x ts
  | otherwise = t : remove x ts
    where
      (y, z) = t

remove' :: Eq a => a -> [(a,b)] -> [(a,b)]
remove' x t 
  = filter (\y -> fst y /= x) t 

quickSort :: (Ord a) => [a] -> [a]
quickSort []
  = []
quickSort (a : as)
  = (quickSort als) ++ a : quickSort ags
    where
      als = filter (<= a) as
      ags = filter (> a) as

allSplits :: [a] -> [([a], [a])]
allSplits as
  = [splitAt n as | n <- [1.. ((length as)-1)]]

prefixes :: [t] -> [[t]]
prefixes t 
  = [pre n t [] | n <- [1 .. length t]]
    where 
      pre :: Int -> [t] -> [t] -> [t]
      pre 0 t acc = acc
      pre n [] acc = acc
      pre n (t : ts) acc = pre (n - 1) ts (acc ++ [t])

substrings :: String -> [String]
substrings [] 
  = []
substrings (x : xs)
  = prefixes (x : xs) ++ substrings xs

perms :: Eq a => [a] -> [[a]]
perms as
  = undefined 

ourConcat :: [a] -> [a] -> [a]
ourConcat [] ys
  = []
ourConcat (x: xs) ys
  = x : ourConcat xs ys

lookUpChar :: Char -> [(Char, String)] -> String
lookUpChar key kv
  = head [v | (k, v) < kv, k == key]


