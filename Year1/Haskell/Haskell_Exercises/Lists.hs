import Data.Char

precedes :: String -> String -> Bool
precedes s t
 = s <= t
-- Returns integers in decreasing order
ints :: Int -> [Int]
-- Pre: n >= 0
ints n
 | n == 0 = []
 | n > 0  = n : ints (n - 1)
-- Sum of numbers in a list
sum' :: [Int] -> Int
sum' [] = 0
sum' (x : xs) = x + sum xs

-- It can be done with case expressions
-- Do not always use it, it doesn't fully fit into functional programming dogma. 
sum'' :: [Int] -> Int
sum'' xs
 = case xs of
  []       -> 0
  (x : xs) -> x + sum xs

-- Returns the position of a specified int x in a given list l.
-- Pre: x <- l. 
pos :: Int -> [Int] -> Int
pos x xs 
 = find 0
  where
  find :: Int -> Int
  find n
   | xs !! n == x = n
   | otherwise    = find (n + 1)
    
-- Returns true iff a given list contains a duplicate
twoSame :: [Int] -> Bool
twoSame xs 
 = findMatch 0 0 
  where
   findMatch :: Int -> Int -> Bool
   findMatch n m
    | n == length xs         = False
    | n == m                 = findMatch n (m + 1) 
    | (xs !! n) == (xs !! m) = True
    | m == length xs - 1     = findMatch (n + 1) 0

--Reverses a list of objects
--It needs to carry out (n-1)! cons (:) operations for a list of length n.
--Hence, its complexity is O((n-1)!).
rev :: [a] -> [a] 
rev [] = []
rev (x : xs) = rev xs ++ [x]

--It  does the same thing but also has a lower complexity.
--For a string of length n it needs to do n operations. O(n).
--Helper function uses an accumulating parameter acc.
rev':: [a] -> [a]
rev' as 
 = reverse as []
  where 
   reverse :: [a] -> [a] -> [a]
   reverse [] acc = acc
   reverse (a : as) acc = reverse as (a : acc)

--Determines whether a string is a substring of anoter one.
substring :: String -> String -> Bool
substring a b
 = compare (length a) 0 a (suff b []) 
 where 
  -- This function takes a string and an accumulating parameter.
  -- It computes a list of substrings of a given string. 
  suff :: String -> [String] -> [String]
  suff [] acc        = acc 
  suff (x : xs) acc  = suff xs ( (x : xs) : acc) 
  -- This function computes a prefix of length n of a given string n.
  pre :: Int ->  String -> String -> String
  pre 0 s acc        = acc
  pre n [] acc       = acc
  pre n (x : xs) acc = pre (n-1) xs (acc ++ [x])
  -- This function uses suff and pre to iterate over a list of suffixes
  -- and compares a to each of their prefixes
  compare :: Int -> Int -> String -> [String] -> Bool 
  -- la := length a, i := the position of a suffx in suffs currnetly tested.
  -- suffs := list of suffixes of b.
  compare la i a suffs
   | i == length suffs             = False
   | a == (pre la (suffs !! i) []) = True
   | otherwise                     = compare la (i + 1) a suffs 

-- Transposes a string according to two template anagrams.
transpose :: String -> String -> String -> String
transpose input an1 an2 
 = compose (length input) []
  where 
   -- Compose uses an iterator and an accumulating parameter to compute the answer.
   compose :: Int -> String -> String
   compose 0 acc = acc
   -- len is length of input that we want to transpose.
   compose len [] = compose (len - 1) (appendTo len [])
   compose len acc =  compose (len - 1) (appendTo len acc)
   -- Appends a correct char from input to the accumulating parameter.
   appendTo :: Int -> String -> String
   appendTo len acc
    = input !! (pos (an2 !! (len - 1)) an1) : acc
   -- Pos returns the position of a char in a given string.
   pos :: Char -> String -> Int
   pos x xs 
    = find 0
     where
      find :: Int -> Int
      find n
       | xs !! n == x = n
       | otherwise    = find (n + 1)

-- Removes whitespace characters from a string.
removeWhitespace :: String -> String
-- Pre: First character is not a whitespace.
removeWhitespace s
 = compose (length s - 1) []
  where
   -- Adds a correct char to an accumulating parameter.
   compose :: Int -> String -> String
   compose n acc 
    | n == 0           = (s !! n) : acc
    | (isSpace (s !! n)) = compose (n - 1) acc
    | otherwise        = compose (n - 1) ((s !! n) : acc)

-- Returns a next word in a string s and the number of chars remainging in s.
nextWord :: String -> (String, Int) 
-- Pre: first character in s is non-whitespace.
nextWord [] 
 = ("", 0)
nextWord (x : xs)
 | isSpace x = nextWord []
 | otherwise = (x : wr, 1 + rem)
   where
     (wr, rem) = nextWord xs
-- Splits up a string into separate words.
splitUp :: String -> [String]
splitUp []
 = []
splitUp (x : xs) 
 | isSpace x = splitUp xs
 | otherwise = w : splitUp (drop (length w) xs)
   where
     (w, rem) = nextWord (x : xs)

take' :: Int -> [a] -> [a]  
take' n _
 | n <= 0 = []
take' _ []
 = []
take' n (x : xs) 
 = x : take (n - 1) xs

drop' :: Int -> [a] -> [a]
drop' n xs
 | n <= 0 = xs
drop' _ []
 = []
drop' n (x : xs)
 = drop' (n - 1) xs

insert :: Int -> [Int] -> [Int]
-- Pre: given list is ordered.
insert x [] = [x]
insert x (y : ys) 
 | x < y     = x : (y : ys)
 | otherwise = y : (insert x ys) 
 -- Sorts a list by repeatedly inserting its elements into a ordered list.
iSort :: [Int] -> [Int]
iSort []       = []
iSort (x : xs) = insert x (iSort xs)

merge :: [Int] -> [Int] -> [Int]
-- Pre: both argument lists are ordered
merge [] []
 = []
merge [] (x : xs)
 = x : xs
merge (x : xs) []
 = x : xs
merge (x : xs) (y : ys)
 | x < y = x : merge xs (y : ys)
 | otherwise = y : merge (x : xs) ys
 
mergeSort :: [Int] -> [Int]
mergeSort []
 = []
mergeSort xs
 = mergeSort' (length xs) xs
  where
   mergeSort' :: Int -> [Int] -> [Int]
   mergeSort' 1 x
    = x
   mergeSort' n xs
    = merge (mergeSort' m xs') (mergeSort' (n - m) xs'')
     where
      m = n `div` 2
      (xs', xs'') = splitAt (m) xs
      

