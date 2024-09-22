{-# LANGUAGE FlexibleInstances #-}
-- 1.

-- (a)

data Colour = Red | Green | Blue
            deriving (Show, Enum)

instance Bounded Colour where
  maxBound = Blue
  minBound = Red

-- (b)

succGreen = succ Green

numRepBlue = fromEnum Blue

numRepZero = toEnum 0::Colour 

allColours = enumFrom Red

data Time = Hour24 Int | WallClock Int Int AmPm

data AmPm = Am | Pm
          deriving (Eq)

instance Show AmPm where
  show Am = "am"
  show Pm = "pm"

to24 :: Time -> Time
to24 (Hour24 t)           = Hour24 t
to24 (WallClock 12 00 Pm) = Hour24 (1200)
to24 (WallClock 12 00 Am) = Hour24 (0000)
to24 (WallClock h m Am)   = Hour24 (100 * h + m)
to24 (WallClock h m Pm)   = Hour24 (100 * (h + 12) + m)

equalTime :: Time -> Time -> Bool
equalTime t1 t2 = time1 == time2
  where
    Hour24 time1 = to24 t1
    Hour24 time2 = to24 t2

-- This function ensures that the time is displayed using 4 digits.
show4d :: Int -> String
show4d n 
  | length (show n) == 1 = "000" ++ (show n)
  | length (show n) == 2 = "00" ++ (show n)
  | length (show n) == 3 = "0" ++ (show n)
  | otherwise            = show n

instance Eq Time where
  (==) = equalTime

instance Show Time where
  show (Hour24 t)           = show4d t ++ "hrs" 
  show (WallClock 12 00 Pm) = "Midday"
  show (WallClock 12 00 Am) = "Midnight"
  show (WallClock h m ampm)   = (show h) ++ "-" ++ (show m) ++ (show ampm) 

type VarName = String

data Fun = Add | Sub | Mul
         deriving (Eq, Show) 

data Exp = Val Int | Id VarName | App Fun Exp Exp
         deriving (Eq, Show) 

type Assignment = (VarName, Exp)

type Program = [Statement]

data Statement = A Assignment | Loop Int Program

type Environment a = [(String, a)]

infixl 1 <--
(<--) :: VarName -> Exp -> Statement
(<--) 
  = (A .) . (,)

loop :: Int -> Program -> Statement
loop = Loop

class Vars a where
  x, y, z :: a

instance Vars String where
  x = "x"
  y = "y"
  z = "z"

instance Vars Exp where
  x = Id "x"
  y = Id "y"
  z = Id "z"

instance Num Exp where
  (*) = App Mul
  (+) = App Add
  (-) = App Sub
  fromInteger a = Val (fromInteger a)

run :: Program -> Environment Int
run p = foldr evalS [] p

evalS :: Statement -> Environment Int -> Environment Int
evalS (A (name, Val n)) env = (name, n) : env 
evalS (A (name, Id name2)) env 
  | elem name (map getName env) = (name2, (lookUp name env)) : [(str, val) | (str, val) <- env, str /= name]
  | otherwise          = (name, (lookUp name2 env)) : env
evalS (A (name, App f e1 e2)) env = undefined -- ToDo 
evalS (Loop n statements) env = evalS (Loop (n - 1) statements) (evalMul statements env)

evalMul :: [Statement] -> Environment Int -> Environment Int
evalMul (s : statements) env = evalMul statements (evalS s env)    
evalMul [] env = env

lookUp :: VarName -> Environment Int -> Int
lookUp name env = head [val | (n, val) <- env, n == name]
  
getName :: (String, a) -> String
getName (name, _) = name












