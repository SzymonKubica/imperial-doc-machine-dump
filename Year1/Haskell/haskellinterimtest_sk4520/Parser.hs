module Parser where

import Data.List
import Data.Maybe
import Data.Char

import Types
import Examples

-------------------------------------------------------------------

-- The following are given...

ops :: [Operator]
ops
  = "+-*/^()$"

opTable :: [(Operator, (Precedence, Associativity))]
opTable
  = [('$',(0,N)), ('(',(1,N)), (')',(1,N)), ('+',(6,L)),
     ('-',(6,L)), ('*',(7,L)), ('/',(7,L)), ('^',(8,R))]

stringToInt :: String -> Int
stringToInt
  = read

showExpr :: Expr -> String
showExpr (ENum n)
  = show n
showExpr (EVar s)
  = s
showExpr (EApp op e e')
  = "(" ++ showExpr e ++ [op] ++ showExpr e' ++ ")"

-------------------------------------------------------------------

precedence :: Operator -> Precedence
-- Pre: the operator has a binding in opTable
precedence op
  = head [prec | (key, (prec, _)) <- opTable, key == op]

associativity :: Operator -> Associativity
-- Pre: the operator has a binding in opTable
associativity op
  = head [assoc | (key, (_, assoc)) <- opTable, key == op]

supersedes :: Operator -> Operator -> Bool
supersedes a b
  = (precedence a > precedence b) 
    || (precedence a == precedence b && (associativity a) == R)

tokenise :: String -> [Token]
-- Pre: The input string is a well-formed expression
tokenise [] = []
tokenise (s : str)  
  | isSpace s = tokenise str 
  | elem s ops = TOp s : tokenise str
  | isDigit s = TNum (stringToInt(s : tokenTail)) : tokenise rest
  | otherwise = TVar (s : tokenTail) : tokenise rest
    where
      (tokenTail, rest) = break (not . isAlphaNum) str

allVars :: String -> [String]
allVars s 
  = removeRepeats [var | TVar var <- tokenise s] []
    where 
      -- Duplicates are removed using an accumulating parameter.
      -- Each element is added to acc and if it already is in there,
      -- we skip it.
      removeRepeats :: [String] -> [String] -> [String]
      removeRepeats [] acc = acc
      removeRepeats (l : ls) acc 
        | elem l acc = removeRepeats ls acc
        | otherwise  = removeRepeats ls (l : acc)

--
-- This function is given
--
expParser :: String -> Expr
expParser s
  = parse (tokenise s) [] ['$']

{-
-- This is the code for the parse function without the extenstion,
-- I Have decided to leave it commented as it is clearer than the 
-- extended version.

parse :: [Token] -> ExprStack -> OpStack -> Expr
parse [] (exp : []) opSt = exp
parse [] expSt opSt = parse [] (app : expSt') opSt'  
  where
   (opS : opSt') = opSt 
   (exp1 : exp2 : expSt') = expSt
   app = EApp opS exp2 exp1
parse ((TNum n) : ts) expSt opSt = parse ts ((ENum n) : expSt) opSt
parse ((TVar v) : ts) expSt opSt = parse ts ((EVar v) : expSt) opSt
parse ((TOp op) : ts) expSt opSt 
  | supersedes op (head opSt) = parse ts expSt (op : opSt)
  | otherwise                 = parse ((TOp op): ts) (app : expSt') opSt'
    where
     (opS : opSt') = opSt 
     (exp1 : exp2 : expSt') = expSt
     app = EApp opS exp2 exp1
-}
-- Here I implemented the extension with brackets.

parse :: [Token] -> ExprStack -> OpStack -> Expr
-- When there are no tokens left, we recursively compute the expression
-- by repeatedly applying operators from the stack to two top expressions.
parse [] (exp : []) opSt = exp
parse [] expSt opSt = parse [] (app : expSt') opSt'  
  where
   (opS : opSt') = opSt 
   (exp1 : exp2 : expSt') = expSt
   app = EApp opS exp2 exp1

-- The algorithm is the same as the one described for the regular parse, 
-- but whenever we encounter '(' bracket it is then forced onto the stack,
-- otherwise it wouldn't comply with the rule that the bracketed exps, 
-- have a higher precendence than anything around them. If we put '(' on the
-- stack, it then parses anything that is after the bracket and puts it on the
-- expression stack. Once the matching ')' bracket is found, we remove the '(' 
-- from the stack and proceed in an usual way. 
parse ((TNum n) : ts) expSt opSt = parse ts ((ENum n) : expSt) opSt
parse ((TVar v) : ts) expSt opSt = parse ts ((EVar v) : expSt) opSt
parse ((TOp op) : ts) expSt opSt 
  | supersedes op (head opSt) = parse ts expSt (op : opSt)
  | op == '('                 = parse ts expSt (op : opSt)
  | op == ')' && opS == '('   = parse ts expSt opSt'
  | otherwise                 = parse ((TOp op): ts) (app : expSt') opSt'
    where
     (opS : opSt') = opSt 
     (exp1 : exp2 : expSt') = expSt
     app = EApp opS exp2 exp1

