data Vertex = Vertex (Float, Float)
  deriving (Show)

data Shape = Triangle Float Float Float | Square Float | Circle Float
            | Polygon [Vertex]
  deriving (Show)

area :: Shape -> Float
area (Triangle a b c)
  = sqrt (s * (s - a) * (s - b) * (s - c)) 
    where
      s = (a + b + c)/2
area (Square a) = a * a
area (Circle r) = pi * r * r
area (Polygon (a : b : [])) = 0.0
area (Polygon (a : b : c : vertices)) 
  = area (Triangle x y z) + area (Polygon (b : c : vertices)) 
    where
    Vertex (xa, ya) = a
    Vertex (xb, yb) = b
    Vertex (xc, yc) = c
    x = sqrt((xa - xb)*(xa - xb) + (ya - yb)*(ya - yb))
    y = sqrt((xc - xb)*(xc - xb) + (yc - yb)*(yc - yb))
    z = sqrt((xc - xa)*(xc - xa) + (yc - ya)*(yc - ya))

-- 3.
data Date = Date(Int, Int, Int)

age :: Date -> Date -> Int
age birth now
  = y1 - y2
    where 
      Date (_, _, y1) = now
      Date (_, _, y2) = birth
      

data Tree a = Empty | Leaf a | Node (Tree a) a (Tree a)

flatten :: Tree a -> [a]
flatten Empty
  = []
flatten (Leaf l)
  = [l]
flatten (Node t1 x t2)
  = flatten t1 ++ (x : flatten t2)
  
flatten' :: Tree a -> [a]
flatten' t 
  = flatten'' t []
    where
      flatten'' :: Tree a -> [a] -> [a]
      flatten'' Empty as
        = as 
      flatten'' (Leaf a) as
        = a : as
      flatten'' (Node t1 x t2) as
        = flatten'' t1 (x : flatten'' t2 as)


-- 5.
data Tree' = Leaf' | Node' Tree' Tree'
          deriving (Eq, Show)

makeTrees :: Int -> [Tree']
makeTrees 0
  = [Leaf']
makeTrees n 
  = [Node' t1 t2 | i < [1..(n-1)], t1 <- makeTrees (n - i), t2 <- makeTrees i]

-- 6.
data Tree'' a = Leaf'' a | Node'' (Tree'' a) (Tree'' a)
              deriving (Show)
-- (a)

build :: [a] -> Tree'' a 
build (l : []) 
  = Leaf'' l
build as 
  = Node'' (build a1) (build a2)
    where
    (a1,a2) = splitAt ((length as) `div` 2) as

-- (b) 

ends :: Tree'' a -> [a]
ends (Leaf'' l)
  =  [l]
ends (Node'' t1 t2)
  = ends t1 ++ ends t2

-- (c)

swap :: Tree'' a -> Tree'' a
swap (Leaf'' a)
  = Leaf'' a
swap (Node'' t1 t2)
  = Node'' (swap t2) (swap t1)

-- A fun extension
reverse' :: [a] -> [a]
reverse' = (ends . swap . build)

-- 7.

-- (a) 

data Tree''' a b = Empty''' | Leaf''' b | Node''' (Tree''' a b) a (Tree''' a b) 
                 deriving(Show)

-- (b)

mapT :: Tree''' a b -> (b -> b) -> (a -> a) -> Tree''' a b
mapT (Leaf''' l) fb fa       = Leaf''' (fb l) 
mapT (Node''' t1 n t2) fb fa = Node''' (mapT t1 fb fa) (fa n) (mapT t2 fb fa)

foldT :: Tree''' a b -> (b -> c) -> (c -> a -> c -> c) -> c -> c
foldT Empty''' fl fn base = base
foldT (Leaf''' l) fl fn base = fl l
foldT (Node''' t1 n t2) fl fn base = fn (foldT t1 fl fn base) n (foldT t2 fl fn base)

-- i.

leaves :: Tree''' a b  -> Int
leaves t = foldT t (\ x -> 1) add' 0
  where 
    add' :: Int -> a -> Int -> Int
    add' f1 n f2 = f1 + f2

build' :: [a] -> Tree''' a a 
build' [] = Empty'''
build' (l : [])
  = Leaf''' l
build' (n : as) 
  = Node''' (build' a1) n (build' a2)
    where
      (a1, a2) = splitAt ((length as) `div` 2) as

sumT :: Tree''' Int Int -> Int
sumT t = foldT t (id) sum' 0
  where
    sum' :: Int -> Int -> Int -> Int 
    sum' l n r = l + n + r

flattenLR :: Tree''' a a -> [a] 
flattenLR t = foldT t (\x -> [x]) makeFlat []
  where 
    makeFlat :: [a] -> a -> [a] -> [a]
    makeFlat l n r = l ++ (n : r) 

flattenRL :: Tree''' a a -> [a] 
flattenRL t = foldT t (\x -> [x]) makeFlat []
  where 
    makeFlat :: [a] -> a -> [a] -> [a]
    makeFlat l n r = r ++ (n : l) 

evaluate :: Tree''' (Int -> Int -> Int) Int -> Int
evaluate t = foldT t (id) apply 0
  where
    apply :: Int -> (Int -> Int -> Int) -> Int -> Int
    apply a f b = f a b









  
 

 
