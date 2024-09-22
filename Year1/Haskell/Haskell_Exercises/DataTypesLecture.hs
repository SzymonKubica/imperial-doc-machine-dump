import Data.Maybe
import Prelude hiding (dropWhile, takeWhile, sum, product, and, or, concat, maximum, minimum)

-- This section defines a binary tree and methods associated with it.
data Tree a = Empty |Leaf a| Node (Tree a) a (Tree a)
  deriving (Show)

size :: Tree a -> Int
size Empty
  = 0
size (Leaf _)
  = 1
size (Node l x r) 
  = 1 + size l + size r

flatten :: Tree a -> [a]
flatten Empty
  = []
flatten (Leaf a)
  = flatten Empty ++ (a : flatten Empty) 
flatten (Node t1 x t2)
  = flatten t1 ++ (x : flatten t2)

insert :: Int -> Tree Int -> Tree Int
-- Pre: The tree is ordered
insert n Empty
  = Leaf n
insert n (Leaf n')
  | n <= n'   = Node (Leaf n) n' Empty
  | otherwise = Node  Empty n' (Leaf n)
insert n (Node t1 x t2)
  | n <= x    = Node (insert n t1) x t2
  | otherwise = Node t1 x (insert n t2)

build :: [Int] -> Tree Int
build xs
  = foldr (insert) Empty xs 

treeSort :: [Int] -> [Int]
treeSort xs
  = flatten (build xs)

depth :: Tree a -> Int
depth Empty 
  = 0
depth (Leaf _)
  = 1
depth (Node t1 x t2) 
  = 1 + max (depth t1) (depth t2)

-- This section contains some higher order functions.
takeWhile :: (a -> Bool) -> [a] -> [a]
takeWhile p []
  = []
takeWhile p (x : xs)
  | p x       = x : takeWhile p xs
  | otherwise = []

dropWhile  :: (a -> Bool) -> [a] -> [a]
dropWhile p []
  = []
dropWhile p (x : xs)
  | p x       =  dropWhile p xs
  | otherwise = x : xs

-- These are the implementations of some binary operations generalised for lists.
sum xs     = foldl (+) 0 xs
product xs = foldl (*) 1 xs
and xs     = foldr (&&) True xs
or xs      = foldr (||) False xs
concat xs  = foldr (++) [] xs
maximum xs = foldl1 max xs
minimum xs = foldl1 min xs


