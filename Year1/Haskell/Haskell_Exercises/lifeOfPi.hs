{-# LANGUAGE InstanceSigs #-}

module Talk where
import Prelude hiding (pi, repeat, head, tail, filter, iterate)
import Control.Applicative(liftA2)

data Stream a = a :< Stream a
infixr 3 :<

repeat :: a -> Stream a
repeat x = xs where xs = x :< repeat x

list :: Int -> Stream a -> [a]
list 0 _ = []
list n (x :< xs) = x : list (n -1) xs

instance Show a => Show (Stream a) where
  show xs = show (list 10 xs)

iterate :: (a -> a) -> a -> Stream a
iterate f x = x :< iterate f (f x) 

nats :: Num a => Stream a 
nats = iterate (+1) 0

(===) :: a -> a -> a
x === y = y

infixl 0 === 

repeat_from_iterate x = 
  repeat x === iterate id x

instance Functor Stream where
  fmap f (x :< xs) = f x :< fmap f xs

functor_id xs = 
  fmap id xs === id xs

functor_comp f g xs =
  fmap (f . g) xs === (fmap f . fmap g) xs

head :: Stream a -> a
head (x :< xs) = x 

tail :: Stream a -> Stream a 
tail (x :< xs) = xs

nats' :: Num a => Stream a 
nats' = 0 :< fmap (+1) nats'

class Functor f => Multiplicative f where
  unit :: f ()
  (><) :: f a -> f b -> f (a, b) 

mult_l_unit u =
  fmap fst (u >< unit) === u

mult_r_unit v =
  fmap snd (unit >< v) === v

mult_assoc xs ys zs = 
  fmap assoc (xs >< (ys >< zs)) == (xs >< ys) >< zs
    where
      assoc :: (a, (b, c)) -> ((a, b), c)
      assoc (x, (y, z)) = ((x, y), z)

instance Multiplicative Stream where
  unit = repeat ()
  (x :< xs) >< (y :< ys) = (x,y) :< (xs >< ys)

{-

class Functor f => Applicative f where
  pure :: a -> f a
  (<*>) :: f (a -> b) -> f a -> f b

-}

pure_from_unit x =
  pure x === fmap (const x) unit

ap_from_mult fs xs = 
  fs <*> xs === fmap (uncurry ($)) (fs >< xs)

instance Applicative Stream where
  pure x = repeat x

  (<*>) :: Stream (a -> b) -> Stream a -> Stream b
  (f :< fx) <*> (x :< xs) = (f x) :< (fx <*> xs)

evens :: Stream Int
evens = pure (* 2) <*> nats

evens' :: Stream Int
evens' = fmap (* 2) nats

fmap_ap f xs = 
  fmap f xs === pure f <*> xs

instance Num a => Num (Stream a) where
  (+) :: Stream a -> Stream a -> Stream a
  --(x :< xs) + (y :< ys) = (x + y) :< (xs + ys)
  xs + ys = pure (+) <*> xs <*> ys
  (*) = liftA2 (*)
  (-) = liftA2 (-)
  abs = fmap abs
  signum = fmap signum
  
  fromInteger = pure . fromInteger

evens'' = 2 * nats
odds = 2 * nats + 1


instance Monad Stream where
  return = repeat
  (>>=) :: Stream a -> (a -> Stream b) -> Stream b
  xs >>= f = undefined

diag :: Stream (Stream a) -> Stream a
diag  ((x :< xs) :< xss) = x :< diag (fmap tail xss)

nats'' = tail nats

tables :: Num a => Stream (Stream a)
tables = nats' :< tables + pure nats'

squares :: Num a => Stream a 
squares = diag tables

class Functor w => Comonad w where
  extract :: w a -> a
  duplicate :: w a -> w (w a)

instance Comonad Stream where
  extract :: Stream a -> a
  extract = head

  duplicate :: Stream a -> Stream (Stream a)
  duplicate = tails

tails :: Stream a -> Stream (Stream a)
tails xs = xs :< tails (tail xs)
  
data Tape a = Tape (Stream a) a (Stream a)

prevs :: Tape a -> Stream a
prevs (Tape us _ _) = us

nextx :: Tape a -> Stream a
nextx (Tape _ _ us) = us

instance Functor Tape where
  fmap f (Tape xs y zs) = Tape (fmap f xs) (f y) (fmap f zs)

prev :: Tape a -> Tape a
prev (Tape (x :< xs) y zs) = Tape xs x (y :< zs) 

next :: Tape a -> Tape a
next (Tape zs y (x :< xs)) = Tape (y :< xs) x xs 

instance Comonad Tape where
  extract :: Tape a -> a
  extract (Tape xs y zs) = y

  duplicate :: Tape a -> Tape (Tape a)
  duplicate ts = Tape (tail (iterate prev ts))
                      ts 
                      (tail (iterate next ts))

instance Show a => Show (Tape a) where
  show (Tape xs y zs) = (show xs ++ show y ++ show zs)

start :: Tape Char
start = Tape (pure ' ') '#' (pure ' ')

(=>>) :: Comonad w => (w a -> b) -> w a -> w b
(=>>) f wx = (fmap f . duplicate) wx

build :: Comonad w => (w a -> a) -> w a -> Stream (w a)
build f t = iterate (f =>>) t 

rule90 :: Tape Char -> Char
rule90 (Tape (x:<xs) y (z:<zs)) = case [x, y, z] of
  ['#', '#', ' '] -> '#'
  [' ', '#', '#'] -> '#'
  [' ', ' ', '#'] -> '#'
  ['#', ' ', ' '] -> '#'
  _               -> ' '

pretty :: Int -> Stream (Tape Char) -> String
pretty 0 _ = ""
pretty n (Tape xs y zs :< ts) =
  reverse (list 30 xs) ++
  [y] ++
  list 30 zs ++ "\n" ++ pretty (n-1) ts
