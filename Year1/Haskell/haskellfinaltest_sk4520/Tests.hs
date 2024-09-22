module Tests where

import IC.TestSuite
import Data.List
import Alloc
import Types
import Examples

-- Provided helper functions and definitions

sortPair (xs, ys)
  = (sort xs, sort ys)

emptyIf
  = ("if",[],[If (Const 0) [] []])

emptyWhile
  = ("while",[],[While (Const 0) []])


-- Test cases begin here

countCase1
  = [
     ('a',"b") ==> 0
    ]

countCase2
  = [
     (3,[2,4,1,3,2,3,3]) ==> 3
    ]

-- Sorted with sort
degreesCase
  = [
     ([1],[]) ==> [(1,0)],
     (([],[]) :: Graph Int) ==> [],
     fig1Left ==> [(1,2),(2,2),(3,2),(4,2)]
    ]

-- Sorted with sort
neighboursCase
  = [
     (1,([],[])) ==> [],
     (1,([1],[])) ==> [],
     (2,fig1Left) ==> [1,4]
    ]

-- Sorted with sortPair (@Tests.hs)
removeNodeCase1
  = [
     ("i",([],[])) ==> ([],[]),
     ("i",factIG) ==> (["n","prod"],[("n","prod")]),
     ("prod",factIG) ==> (["i","n"],[])
    ]

-- Sorted with sortPair (@Tests.hs)
removeNodeCase2
  = [
     (1,([1],[])) ==> ([],[])
    ]

-- Sorted with sort
colourGraphCase1
  = [
     (1,([],[]) :: Graph Int) ==> [],
     (0,fig1Left) ==> sort [(2,0),(1,0),(3,0),(4,0)],
     (2,fig1Middle) ==> sort [(2,2),(1,0),(3,2),(4,1)]
    ]

-- Sorted with sort
colourGraphCase2
  = [
      (2,fig3IG) ==> sort [("a",0),("b",0),("c",0),("d",2),("n",1)],
      (3,fig3IG) ==> sort [("a",3),("b",0),("c",3),("d",2),("n",1)]
    ]

-- Sorted with sort
buildIdMapCase
  = [
      factColouring ==> sort [("return","return"),("i","R2"),("n","R2"),("prod","R1")],
      fig3Colouring ==> sort [("return","return"),("a","R3"),("b","b"),("c","R3"),("d","R2"),("n","R1")]
    ]

buildArgAssignmentsCase
  = [
      ([],idMap1) ==> [],
      (["x","y"],idMap1) ==> [Assign "R6" (Var "x"),Assign "R1" (Var "y")]
    ]

renameExpCase
  = [
      (e1,idMap1) ==> Apply Add (Var "a") (Var "R1"),
      (e2,idMap1) ==> Apply Mul (Apply Add (Var "R6") (Const 2)) (Var "R1")
    ]

renameFunCase
  = [
      (fact,factIdMap) ==> factTransformed,
      (fig3,fig3IdMap) ==> fig3Transformed
    ]

-- Sorted with sortGraph (@Types.hs)
buildIGCase
  = [
      [] ==> ([],[]),
      factLiveVars ==> factIG,
      fig3LiveVars ==> fig3IG
    ]

-- Sorted with sort
liveVarsCase
  = [
      factCFG ==> factLiveVars,
      fig3CFG ==> fig3LiveVars
    ]

-- Sorted with sortCFG (@Types.hs)
buildCFGCase
  = [
      fact ==> factCFG,
      fig3 ==> fig3CFG,
      emptyIf ==> [(("_",[]),[])],
      emptyWhile ==> [(("_",[]),[0])]
    ]


allTestCases
  = [  TestCase  "count1"               (uncurry count)
                                        countCase1
    ,  TestCase  "count2"               (uncurry count)
                                        countCase2
    ,  TestCase  "degrees"              (sort . degrees)
                                        degreesCase
    ,  TestCase  "neighbours"           (sort . uncurry neighbours)
                                        neighboursCase
    ,  TestCase  "removeNode1"          (sortPair . uncurry removeNode)
                                        removeNodeCase1
    ,  TestCase  "removeNode2"          (sortPair . uncurry removeNode)
                                        removeNodeCase2
    ,  TestCase  "colourGraph1"         (sort . uncurry colourGraph)
                                        colourGraphCase1
    ,  TestCase  "colourGraph2"         (sort . uncurry colourGraph)
                                        colourGraphCase2
    ,  TestCase  "buildIdMap"           (sort . buildIdMap)
                                        buildIdMapCase
    ,  TestCase  "buildArgAssignments"  (uncurry buildArgAssignments)
                                        buildArgAssignmentsCase
    ,  TestCase  "renameExp"            (uncurry renameExp)
                                        renameExpCase
    ,  TestCase  "renameFun"            (uncurry renameFun)
                                        renameFunCase
    ,  TestCase  "buildIG"              (sortGraph . buildIG)
                                        buildIGCase
    ,  TestCase  "liveVars"             (map sort . liveVars)
                                        liveVarsCase
    ,  TestCase  "buildCFG"             (sortCFG . buildCFG)
                                        buildCFGCase
    ]

runTests = mapM_ goTest allTestCases

main = runTests
