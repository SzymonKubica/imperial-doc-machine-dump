module Calculus where

import Data.Maybe

data UnOp = Neg | Sin | Cos | Log
          deriving (Eq, Ord, Show)

data BinOp = Add | Mul | Div
           deriving (Eq, Ord, Show)

data Exp = Val Double | Id String | UnApp UnOp Exp | BinApp BinOp Exp Exp
         deriving (Eq, Ord, Show)

type Env = [(String, Double)]


---------------------------------------------------------------------------
-- Type classes and class instances

class Vars a where
  x, y, z :: a

instance Vars Exp where
  x = Id "x"
  y = Id "y"
  z = Id "z"

instance Vars Double where
  x = 4.3
  y = 9.2
  z = -1.7

-- The instances were modified according to the extension
-- However, optimised diff gets rid of redundancies, thus failing tests.
-- In order to see the optimisation working, 
-- the following functions need to be uncommented
{-
negate' :: Exp -> Exp
negate' (Val 0.0) = (Val 0.0)
negate' exp       = UnApp Neg exp

Add' :: Exp -> Exp -> Exp
Add' exp (Val 0.0) = exp
Add' (Val 0.0) exp = exp
Add' exp exp'      = BinApp Add exp exp'

Mul' :: Exp -> Exp -> Exp
Mul' exp (Val 1.0) = exp
Mul' (Val 1.0) exp = exp
Mul' exp exp'      = BinApp Mul exp exp'

Div' :: Exp -> Exp -> Exp
Div' (Val 0.0) exp = (Val 0.0)
Div' exp (Val 1.0) = exp
Div' exp exp'      = BinApp Div exp exp'
-}

instance Num Exp where
  fromInteger = undefined 
--negate      = negate'
  negate      = UnApp Neg
--(+)         = Add' 
  (+)         = BinApp Add
--(*)         = Mul'
  (*)         = BinApp Mul
-- Leave the following two undefined...
  signum      = undefined
  abs         = undefined

instance Fractional Exp where
  fromRational = undefined
--(/)          = Div'
  (/)         = BinApp Div
-- Leave the following one undefined...
  recip        = undefined

instance Floating Exp where
  sin     = UnApp Sin
  cos     = UnApp Cos
  log     = UnApp Log
-- Leave the following fifteen undefined...
  tan     = undefined
  asin    = undefined
  acos    = undefined
  atan    = undefined
  pi      = undefined
  exp     = undefined
  sqrt    = undefined
  (**)    = undefined
  logBase = undefined
  sinh    = undefined
  cosh    = undefined
  tanh    = undefined
  asinh   = undefined
  acosh   = undefined
  atanh   = undefined


---------------------------------------------------------------------------

lookUp :: Eq a => a -> [(a, b)] -> b
-- Pre: The list contains a biding for every key, i.e. the search will succeed.
lookUp k kv
  = fromJust(lookup k kv)

-- These tables allow us to avoid complex type matching in eval and showExp.
-- The first two contain key-value pairs for unary operators.
unOpTable :: [(UnOp, Double -> Double)]
unOpTable = [(Neg, (negate)),(Sin, (sin)),(Cos, (cos)),(Log, (log))]

unOpShow :: [(UnOp, String)]
unOpShow = [(Neg, "-" ),(Sin, "sin"),(Cos, "cos"),(Log, "log")]

-- These tables contain key-value pairs for binary operators.
binOpTable :: [(BinOp, Double -> Double -> Double)]
binOpTable = [(Add, (+)),(Mul, (*)),(Div, (/))]

binOpShow :: [(BinOp, String)]
binOpShow = [(Add, "+"),(Mul, "*"),(Div, "/")]

-- This function converts an Exp into a more readable string.
showExp :: Exp -> String
-- If the expression is a value, it shows it.
showExp (Val d)
  = show d

-- If the expression is a variable, its name is printed.
showExp (Id x)
  = x

-- If the exp is an unary operation applied to a variable,
-- we enclose the variable in brackets.
showExp (UnApp op (Id x))
  = "(" ++ (lookUp op unOpShow) ++ "(" ++ (showExp (Id x)) ++ "))"

-- This case ensures that a + (-b) is displayed as a - b.
showExp (BinApp Add exp (UnApp Neg exp'))
  = "(" ++ showExp exp ++ "-" ++ showExp exp' ++ ")"

-- Special case: displaying squares.
-- Multiplying two variables concatenates them.
showExp (BinApp Mul (Id x) (Id y))
  | x == y = showExp (Id x) ++ "^2"
  | otherwise = showExp (Id x) ++ showExp (Id y)

-- When we multiply a product by a variable, we can concatenate names of vars.
showExp (BinApp Mul (Id x) (BinApp Mul (Val a) (Id y)))
  = showExp (Val a) ++ "*" ++ x ++ y
showExp (BinApp Mul (BinApp Mul (Val a) (Id y)) (Id x))
  = showExp (Val a) ++ "*" ++ y ++ x

-- If we take a unary operation of a product, we need to put it in brackets.
showExp (UnApp op (BinApp Mul exp exp'))
  = (lookUp op unOpShow) ++ "(" ++ (showExp exp) ++ "*" ++ (showExp exp')++ ")"

-- Bracketing. 
-- In case of multiplication or division, we can omit brackets:
showExp (BinApp Mul exp exp')
  = (showExp exp) ++ (lookUp Mul binOpShow) ++ (showExp exp') 

showExp (BinApp Div exp exp')
  = (showExp exp) ++ (lookUp Div binOpShow) ++ (showExp exp') 

-- Otherwise, we need to put the brackets.
showExp (UnApp op exp)
  = "(" ++ (lookUp op unOpShow) ++ (showExp exp) ++ ")" 

showExp (BinApp op exp exp')
  = "(" ++ (showExp exp) ++ (lookUp op binOpShow) ++ (showExp exp') ++ ")"

-- Evaluation is performed recursively depending on the type of exp.
-- If exp contains an actual value, it is returned.
eval :: Exp -> Env -> Double
eval (Val d) env
  = d 

-- If exp is a variable (Id "x") its value is looked up in the environment.
eval (Id x) env
  = lookUp x env

-- When exp is a composite expression, 
-- the operator of this exp is looked-up in the respective table.
-- Then it is applied to recursively computed values.
eval (UnApp op exp) env
  =  (lookUp op unOpTable) (eval exp env) 

eval (BinApp op exp exp') env
  =  (lookUp op binOpTable) (eval exp env) (eval exp' env) 

{-

This is the previous version of diff, which the spec advised to leave commented.
diff :: Exp -> String -> Exp
-- When a constant expression is differentiated, returns 0.
diff (Val d) x
  = Val 0.0
-- When the expression is a variable, then it checks if we differentiate it. 
-- If we differentiate with respecto to this variable, returns 1. Otherwise 0.
diff (Id y) x
  | y == x    = Val 1.0 
  | otherwise = Val 0.0
-- The derivative of negative expression. 
diff (UnApp Neg exp) x
  = UnApp Neg (diff exp x)
-- When differentiating a sum, we compute recursively a sum of two derivatives.
diff (BinApp Add exp exp') x
  = BinApp Add (diff exp x) (diff exp' x) 
-- When differntiating a product, we use the product rule.
diff (BinApp Mul exp exp') x
  = BinApp Add (BinApp Mul exp (diff exp' x))(BinApp Mul (diff exp x) exp')
-- When differntiating a division, we use the quotient rule.
diff (BinApp Div exp exp') x
  = BinApp Div difference (BinApp Mul exp' exp')
    where
      difference = BinApp Add prod1 (UnApp Neg prod2)
      prod1      = BinApp Mul (diff exp x) exp'
      prod2      = BinApp Mul exp (diff exp' x)
-- A derivative of sin of an expression is computed using chain rule.
diff (UnApp Sin exp) x
  = BinApp Mul (UnApp Cos exp) (diff exp x) 
-- A derivative of cos of an expression is computed using chain rule.
diff (UnApp Cos exp) x
  = UnApp Neg (BinApp Mul (UnApp Sin exp) (diff exp x))
-- A derivative of log of an expression is computed using chain rule.
diff (UnApp Log exp) x 
  = BinApp Div (diff exp x) exp

-}

diff :: Exp -> String -> Exp
-- When a constant expression is differentiated, returns 0.
diff (Val d) x
  = Val 0.0

-- When the expression is a variable, then it checks if we differentiate it. 
-- If we differentiate with respect to this variable, returns 1. Otherwise 0.
diff (Id y) x
  | y == x    = Val 1.0 
  | otherwise = Val 0.0

-- The derivative of negative expression. 
diff (UnApp Neg exp) x
  = negate (diff exp x)

-- When differentiating a sum, we compute recursively a sum of two derivatives.
diff (BinApp Add exp exp') x
  = (diff exp x) + (diff exp' x) 

-- When differntiating a product, we use the product rule.
diff (BinApp Mul exp exp') x
  = (exp * (diff exp' x)) + ((diff exp x) * exp')

-- When differntiating a division, we use the quotient rule.
diff (BinApp Div exp exp') x
  = ((diff exp x) * exp') + (negate(exp * (diff exp' x))) / (exp' * exp')

-- A derivative of sin of an expression is computed using chain rule.
diff (UnApp Sin exp) x
  = (cos exp) * (diff exp x)

-- A derivative of cos of an expression is computed using chain rule.
diff (UnApp Cos exp) x
  = negate ((sin exp) * (diff exp x))
  
-- A derivative of log of an expression is computed using chain rule.
diff (UnApp Log exp) x 
  = (diff exp x) / exp

-- Maclaurin series is computed using three helper lists.
-- diffs - A list of nth derivatives of exp,
-- pows  - A list of nth powers of x,
-- facts - A list of factorials of nth number.
-- The list vals is couputed by applying eval to each of diffs. 
-- The final result is obtained by summing terms of Maclaurin series.
-- The terms are from zipWith3 that multiplies val and pow and divides by fact.
maclaurin :: Exp -> Double -> Int -> Double
maclaurin exp x n 
  = sum (zipWith3 (\d p f -> d * p / f) vals pows facts)
    where 
      vals  = map ((flip eval) [("x", 0.0)]) diffs 
      diffs = take n (iterate ((flip diff) "x") exp)
      pows  = take n (iterate (*x) 1)
      facts = take n (scanl (*) 1 [1..])


---------------------------------------------------------------------------
-- Test cases...

e1, e2, e3, e4, e5, e6 :: Exp

-- 5*x
e1 = BinApp Mul (Val 5.0) (Id "x")

-- x*x+y-7
e2 = BinApp Add (BinApp Add (BinApp Mul (Id "x") (Id "x")) (Id "y"))
                (UnApp Neg (Val 7.0))

-- x-y^2/(4*x*y-y^2)::Exp
e3 = BinApp Add (Id "x")
            (UnApp Neg (BinApp Div (BinApp Mul (Id "y") (Id "y"))
            (BinApp Add (BinApp Mul (BinApp Mul (Val 4.0) (Id "x")) (Id "y"))
                        (UnApp Neg (BinApp Mul (Id "y") (Id "y"))))))

-- -cos x::Exp
e4 = UnApp Neg (UnApp Cos (Id "x"))

-- sin (1+log(2*x))::Exp
e5 = UnApp Sin (BinApp Add (Val 1.0)
                           (UnApp Log (BinApp Mul (Val 2.0) (Id "x"))))

-- log(3*x^2+2)::Exp
e6 = UnApp Log (BinApp Add (BinApp Mul (Val 3.0) (BinApp Mul (Id "x") (Id "x")))
                           (Val 2.0))
