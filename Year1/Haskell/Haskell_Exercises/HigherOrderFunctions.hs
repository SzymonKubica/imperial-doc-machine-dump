import Data.Char

depunctuate :: String -> String
depunctuate []
  = []
depunctuate (c : cs)
  | elem c ".,:" = depunctuate cs
  | otherwise    = c : depunctuate cs

depunctuate' :: String -> String
depunctuate' s
  = filter (flip(notElem) ".,:") s

makeString :: [Int] -> String
makeString []
  = []
makeString (n : ns)
  = chr n : makeString ns

makeString' :: [Int] -> String
makeString' xs
  = map chr xs

enpower :: [Int] -> Int 
enpower [n]
  = n
enpower (n : ns)
  = enpower ns ^ n

enpower' :: [Int] -> Int 
enpower' n 
  = foldl1 (^) n

revAll :: [[a]] -> [a]
revAll []
  = []
revAll (x : xs)
  = reverse x ++ revAll xs

revAll' :: [[a]] -> [a]
revAll' xs
  = concatMap reverse xs
 
rev :: [a] -> [a] 
rev xs
  = rev' xs []
  where
    rev' [] ys
      = ys
    rev' (x : xs) ys
      = rev' xs (x : ys)

rev'' :: [a] -> [a]
rev'' xs
  = foldl (flip(:)) [] xs

dezip :: [(a, b)] -> ([a], [b])
dezip []
  = ([], [])
dezip ((x, y) : ps)
  = (x : xs, y : ys)
    where
      (xs, ys) = dezip ps

dezip' :: [(a, b)] -> ([a], [b]) 
dezip' xs 
  = foldr push ([], []) xs
    where
    push :: (a,b) -> ([a], [b]) -> ([a], [b]) 
    push (x, y) (xs, ys) = (x : xs, y : ys)

allSame :: [Int] -> Bool
allSame xs
  = and (zipWith (==) xs (tail xs))

facts :: [Int]
facts = scanl (*) 1 [1..]

appE :: Int -> Float
appE n = sum (map ((1/) . fromIntegral) (take n facts))

squash :: (a -> a -> b) -> [a] -> [b]
squash f as
  = zipWith f as (tail as)

squashR :: (a -> a -> b) -> [a] -> [b]
squashR f (a : [])
  = []
squashR f (a : a' : as)
  = (f a a') : squashR f (a' : as) 

-- Pre: given list contains at lease one element
converge :: (a -> a -> Bool) -> [a] -> a
converge f (a : []) 
  = a
converge f (a : a' : as) 
  | f a a'    = a
  | otherwise = converge f (a' : as)

appE' :: Float -> Float
appE' err
  = converge test (scanl1 (+) (map ((1/) . fromIntegral) (scanl (*) 1 [1..])))
    where
      test :: Float -> Float -> Bool
      test s s'
        = abs (s - s') < err

-- TODO exercise 6.

-- 7.
repeatUntil :: (a -> Bool) -> (a -> a) -> a -> a
repeatUntil c f a
  | c a       = a
  | otherwise = repeatUntil c f (f a)

-- 8.
any' :: (a -> Bool) -> [a] -> Bool
any' p = or . (map p)  

any'' :: (a -> Bool) -> [a] -> Bool
any''  = or <.> map   

any''' :: (a -> Bool) -> [a] -> Bool
any''' p = (.).(.) or map p 

all' :: (a -> Bool) -> [a] -> Bool
all' p = and . (map p)  

all'' :: (a -> Bool) -> [a] -> Bool
all''  = and <.> map   

--all''' :: (a -> Bool) -> [a] -> Bool
--all'''  = and <.> map   

-- 9.
isElem :: Eq a => a -> [a] -> Bool
isElem = any . (==) 

-- 10.
-- TODO  the (c) extension
infixl 9 <.>
(<.>) :: (c -> d) -> (a -> b -> c) -> a -> b -> d
--(<.>) f2 f1 a b
-- = f2 (f1 a b) 
(<.>) = (.).(.)

-- 11.
pipelineL :: [(a -> a)] -> [a] -> [a]
pipelineL [] as = as
pipelineL (f : fs) as 
 = pipelineL fs (map f as)

--TODO
pipelineR :: [(a -> a)] -> [a] -> [a]
pipelineR fs as = map (foldr (.) id fs) as
  
foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' f u (a : []) 
  = f a u
foldr' f u (a : as)
  = f a (foldr' f u as) 


   



