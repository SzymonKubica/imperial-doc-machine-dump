module Examples where

import Types

s1, s2, s3, s4 :: String
e1, e2, e3, e4 :: Expr

s1
  = "1+7*9"
e1 
  = EApp '+' (ENum 3) (EApp '*' (ENum 7) (ENum 9))

s2
  = "4+x^2-8*y"
e2
  = EApp '-' (EApp '+' (ENum 4) (EApp '^' (EVar "x") (ENum 2))) 
             (EApp '*' (ENum 8) (EVar "y"))

s3
  = "((x))"
e3
  = EVar "x"

s4 
  = "(4+x)^(2-8)*y"
e4
  = EApp '*' (EApp '^' (EApp '+' (ENum 4) (EVar "x")) 
                       (EApp '-' (ENum 2) (ENum 8))) 
             (EVar "y")

