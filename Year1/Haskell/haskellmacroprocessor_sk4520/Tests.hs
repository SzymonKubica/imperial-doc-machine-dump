module Tests where

import IC.TestSuite

import MP hiding (main)

lookUpTestCases
  = [ ("A", [("A", 8), ("B",9), ("C",5), ("A",7)]) ==> [8,7]
    , ("a", []) ==> []
    , ("test1", [("test1", 5), ("test1",7), ("B",9), ("C",5)]) ==> [5,7]
    , ("test2", [("test2", 3), ("k",9), ("k",5), ("test2",6)]) ==> [3,6]
    , ("test3", [("test3", 7), ("B",9), ("test3",9), ("C",5)]) ==> [7,9]
    , ("test4", [("l",9), ("test4", 2), ("l",5), ("test4",6)]) ==> [2,6]
    , ("a", [("a", 9)]) ==> [9]
    , ("c", [("a", 5)]) ==> []
    , ("d", [("_", 4)]) ==> []
    , ("a", [("b", 9)]) ==> []
    ]

splitTextTestCases
  = [ (" .,", "A comma, then some words.")
        ==> (" ,   .",["A","comma","","then","some","words",""])
    , ("", "")
        ==> ("", [""])
    , (".", "A.B")
        ==> (".", ["A","B"])
    , (":", "x:y")
        ==> (":", ["x","y"])
    , (",", "c,k")
        ==> (",", ["c","k"])
    , (",:", "o,p:let")
        ==> (",:", ["o","p","let"])
    , ("+=", "2+2=4")
        ==> ("+=", ["2","2","4"])
    , ("+=", "2 + 1 = 5")
        ==> ("+=", ["2 "," 1 "," 5"])
    , (" ", " A")
        ==> (" ", ["", "A"])
    , (":./, ", ":./, a test of leading separators.")
        ==> (":./,     .",["","","","","","a","test","of","leading","separators",""])
    ]

combineTestCases
  = [ (" ,   .", ["A","comma","","then","some","words",""])
        ==> ["A"," ","comma",",",""," ","then"," ","some"," ","words",".",""]
    , (":./,     .",["","","","","","a","test","of","leading","separators",""])
        ==> ["",":","",".","","/","",",",""," ","a"," ","test"," ","of"," ","leading"," ","separators",".",""]
    , ("", [""])
        ==> [""]
    , (".", ["A","B"])
        ==> ["A",".","B"]
    , (",", ["x","y"])
        ==> ["x",",","y"]
    , (",:", ["x","y",""])
        ==> ["x",",","y",":",""]
    , (" ,: ", ["a","b","x","y",""])
        ==> ["a"," ","b",",","x",":","y"," ",""]
    , ("',:/", ["x","k","l","j","e"])
        ==> ["x","'","k",",","l",":","j","/","e"]
    , ("',:/", ["","","","",""])
        ==> ["","'","",",","",":","","/",""]
    , (" ", ["", "A"])
        ==> [""," ","A"]
    ]

getKeywordDefsTestCases
  = [ ["$rule Reproduce this precisely -- or else!!"]
        ==> [("$rule","Reproduce this precisely -- or else!!")]
    , ["$x Define x", "$y 55"]
        ==> [("$x","Define x"),("$y","55")]
    , ["$a A", "$b B", "$c C"]
        ==> [("$a","A"),("$b","B"),("$c","C")]
    , []
        ==> []
    , ["$x-y-z $$$"]
        ==> [("$x-y-z","$$$")]
    , ["$$ something to think about"]
        ==> [("$$","something to think about")]
    , ["$fruit apple"]
        ==> [("$fruit","apple")]
    , ["$vehicle car"]
        ==> [("$vehicle","car")]
    , ["$place mountain"]
        ==> [("$place","mountain")]
    , ["$crazySeparator this is a test how it handles multiple        spaces"]
        ==> [("$crazySeparator","this is a test how it handles multiple        spaces")]
    , ["$ meanie!"]
        ==> [("$","meanie!")]
    , ["$var  Tristan Allwood"]
        ==> [("$var", " Tristan Allwood")]
    ]

expandTestCases
  = [ ("The capital of $1 is $2", "$1 Peru\n$2 Lima.")
        ==> "The capital of Peru is Lima."
    , ("The time is $a", "$a now.")
        ==> "The time is now."
    , ("The car is $adj", "$adj fast.")
        ==> "The car is fast."
    , ("Haskell is $what", "$what a programming language.")
        ==> "Haskell is a programming language."
    , ("The question is $about", "$about that.")
        ==> "The question is that."
    , ("This function is $type", "$type recursive.")
        ==> "This function is recursive."
    , ("It is better to avoid using length $because", "$because because it is slow.")
        ==> "It is better to avoid using length because it is slow."
    , ("It is good to use $what", "$what type-matching.")
        ==> "It is good to use type-matching."
    -- This test case checks how it deals with leading special characters.
    , ("It is better not to use $what", "$what == True.")
        ==> "It is better not to use == True."
    , ("Keywords (e.g. $x, $y, $z...) may appear anwhere, e.g. <$here>.",
       "$x $a\n$y $b\n$z $c\n$here $this-is-one")
        ==> "Keywords (e.g. $a, $b, $c...) may appear anwhere, e.g. <$this-is-one>."
    ]

allTestCases
  = [ TestCase "lookUp"  (uncurry lookUp)
                         lookUpTestCases
    , TestCase "splitText"   (uncurry splitText)
                         splitTextTestCases
    , TestCase "combine" (uncurry combine)
                         combineTestCases

    , TestCase "getKeywordDefs" getKeywordDefs
                                getKeywordDefsTestCases

    , TestCase "expand"  (uncurry expand)
                         expandTestCases
    ]

runTests = mapM_ goTest allTestCases

main = runTests
