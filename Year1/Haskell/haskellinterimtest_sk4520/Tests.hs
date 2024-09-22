module Tests where

import IC.TestSuite
import Data.List
import Parser
import Types
import Examples


precedenceCase
  = [
      ('+') ==> 6,
      ('-') ==> 6,
      ('*') ==> 7,
      ('/') ==> 7,
      ('^') ==> 8,
      ('(') ==> 1,
      (')') ==> 1,
      ('$') ==> 0
    ]

associativityCase
  = [
      ('+') ==> L,
      ('-') ==> L,
      ('*') ==> L,
      ('/') ==> L,
      ('^') ==> R,
      ('(') ==> N,
      (')') ==> N,
      ('$') ==> N
    ]

supersedesCase
  = [
      ('+','-') ==> False,
      ('*','^') ==> False,
      ('^','^') ==> True,
      ('*','+') ==> True,
      -- Tested how the brackets behave for the extension.
      ('(','-') ==> False,
      ('(','^') ==> False,
      ('(','/') ==> False,
      ('(','+') ==> False,
      -- Apparently the '(' will need to be forced onto the stack,
      -- whenever any operator of higher precedence will show up before.
      ('(','$') ==> True,
      -- Similarly
      (')','-') ==> False,
      (')','^') ==> False,
      (')','/') ==> False,
      (')','+') ==> False,
      (')','$') ==> True

    ]

-- These are all sorted in lexographic order
allVarsCase
  = [
      ("0") ==> [],
      ("x") ==> ["x"],
      ("x+y") ==> ["x","y"],
      ("2*(a+(b*c))") ==> ["a","b","c"],
      ("long+long+s") ==> ["long", "s"],
      ("long+s+long") ==> ["long", "s"],
      s1 ==> [],
      s2 ==> ["x", "y"],
      s3 ==> ["x"],
      s4 ==> ["x", "y"]
    ]

tokeniseCase
  = [
      ("0") ==> [TNum 0],
      ("x") ==> [TVar "x"],
      ("x+1") ==> [TVar "x",TOp '+',TNum 1],
      ("+") ==> [TOp '+'],
      ("2*(x+1)") ==> [TNum 2,TOp '*',TOp '(',TVar "x",TOp '+',TNum 1,TOp ')'],
      ("2  * (\t \n x+   \t1)  ") ==> [TNum 2,TOp '*',TOp '(',TVar "x",TOp '+',TNum 1,TOp ')'],
      ("longname") ==> [TVar "longname"],
      ("123") ==> [TNum 123],
      ("longname 123") ==> [TVar "longname", TNum 123],
      ("x2") ==> [TVar "x2"]
    ]

expParserCase
  = [
      ( "0") ==> ENum 0,
      ( "x") ==> EVar "x",
      ( "x+1") ==> EApp '+' (EVar "x") (ENum 1),
      ( "x+2*3^2") ==> EApp '+' (EVar "x") (EApp '*' (ENum 2) (EApp '^' (ENum 3) (ENum 2))),
      ( "2^3^4") ==> EApp '^' (ENum 2) (EApp '^' (ENum 3) (ENum 4)),
      ( "2*3*4") ==> EApp '*' (EApp '*' (ENum 2) (ENum 3)) (ENum 4),
      ( "2+3-4") ==> EApp '-' (EApp '+' (ENum 2) (ENum 3)) (ENum 4),
      ( "(((6)))") ==> ENum 6,
      ( "2+(3-4)") ==> EApp '+' (ENum 2) (EApp '-' (ENum 3) (ENum 4)),
      ( "(2^3)^4") ==> EApp '^' (EApp '^' (ENum 2) (ENum 3)) (ENum 4),
      ( "(3+4)*(5+6)^12" ==> EApp '*' (EApp '+' (ENum 3) (ENum 4)) (EApp '^' (EApp '+' (ENum 5) (ENum 6)) (ENum 12)))
    ]

allTestCases
  = [  TestCase  "precedence"          (precedence)
                                       precedenceCase
     , TestCase  "associativity"       (associativity)
                                       associativityCase
     , TestCase  "supersedes"          (uncurry supersedes)
                                       supersedesCase
     , TestCase  "allVars"             (sort . allVars)
                                       allVarsCase
     , TestCase  "tokenise"            (tokenise)
                                       tokeniseCase
     , TestCase  "expParser"           (expParser)
                                       expParserCase
    ]

runTests = mapM_ goTest allTestCases

main = runTests
