module Tests where

import IC.TestSuite
import IC.Graphics
import LSystems

import Data.List (sort)

angleTestCases
  = [ cross         ==> 90
    , (1, "", [])   ==> 1
    , (180, "", []) ==> 180
    , triangle      ==> 90
    , arrowHead     ==> 60
    , peanoGosper   ==> 60
    , snowflake     ==> 60
    , dragon        ==> 45
    , tree          ==> 45
    , bush          ==> 22.5
    ]

axiomTestCases
  = [ (0, "+", []) ==> "+"
    , (0, "M", []) ==> "M"
    , cross        ==> "M-M-M-M"
    , triangle     ==> "-M"
    , arrowHead    ==> "N"
    , peanoGosper  ==> "M"
    , snowflake    ==> "M--M--M"
    , dragon       ==> "MX"
    , tree         ==> "M"
    , bush         ==> "X"
    ]

rulesTestCases
  = [ cross       ==> [ ('M', "M-M+M+MM-M-M+M")
                      , ('+', "+")
                      , ('-', "-")
                      ]
    , triangle    ==> [('M', "M+M-M-M+M")
                      ,('+', "+")
                      ,('-', "-")
                      ]
    , arrowHead   ==> [('M', "N+M+N")
                      ,('N', "M-N-M")
                      ,('+', "+")
                      ,('-', "-")
                      ]
    , peanoGosper ==> [('M', "M+N++N-M--MM-N+")
                      ,('N', "-M+NN++N+M--M-N")
                      ,('+', "+")
                      ,('-', "-")
                      ]
    , snowflake   ==> [('M', "M+M--M+M")
                      ,('+', "+")
                      ,('-', "-")
                      ]
    , dragon      ==> [('M', "A")
                      ,('X', "+MX--MY+")
                      ,('Y', "-MX++MY-")
                      ,('A', "A")
                      ,('+', "+")
                      ,('-', "-")
                      ]
    , tree        ==> [('M', "N[-M][+M][NM]")
                      ,('N', "NN")
                      ,('[', "[")
                      ,(']', "]")
                      ,('+', "+")
                      ,('-', "-")
                       ]
    , bush        ==> [('X', "M-[[X]+X]+M[+MX]-X")
                      ,('M', "MM")
                      ,('[', "[")
                      ,(']', "]")
                      ,('+', "+")
                      ,('-', "-")
                      ]

    , (0, "", [ ('M', "N") ])
        ==> [ ('M', "N") ]
    , (8, "", [ ('T', "E") ])
        ==> [ ('T', "E") ]
    ]

{- Note: these test cases use angle/axiom/rules, and will fail the test
 - suite with Argument exceptions until those functions are correctly
 - implemented.
 -}
lookupCharTestCases
  = [ ('X', [ ('X', "Yes")
            , ('Y', "No")])  ==> "Yes"
    , ('X', [ ('Y', "No")
            , ('X', "Yes")]) ==> "Yes"
    , ('M',  (rules peanoGosper))
      ==> "M+N++N-M--MM-N+"
    , ('+', (rules triangle))
      ==> "+"
    , ('M', (rules bush))
      ==> "MM"
    , ('N', (rules tree))
      ==> "NN"
    , ('A', (rules dragon))
      ==> "A"
    , ('+', (rules snowflake))
      ==> "+"
    , ('N', (rules arrowHead))
      ==> "M-N-M"
    , ('+', (rules cross))
      ==> "+"
    ]

expandOneTestCases
  = [ (axiom triangle, rules triangle)
        ==> "-M+M-M-M+M"
    , (axiom cross, rules cross)
        ==> "M-M+M+MM-M-M+M-M-M+M+MM-M-M+M-M-M+M+MM-M-M+M-M-M+M+MM-M-M+M"
    , (axiom peanoGosper, rules peanoGosper)
        ==> "M+N++N-M--MM-N+"
    , (axiom bush, rules bush)
        ==> "M-[[X]+X]+M[+MX]-X"
    , (axiom tree, rules tree)
        ==> "N[-M][+M][NM]"
    , (axiom dragon, rules dragon)
        ==> "A+MX--MY+"
    , (axiom snowflake, rules snowflake)
        ==> "M+M--M+M--M+M--M+M--M+M--M+M"
    , (axiom arrowHead, rules arrowHead)
        ==> "M-N-M"
    , ("A", [('A', "B")]) ==> "B"
    , ("A", [('A', "B-A-B")]) ==> "B-A-B"
    ]

expandTestCases
  = [ (axiom arrowHead, 2, rules arrowHead)
        ==> "N+M+N-M-N-M-N+M+N"
    , (axiom arrowHead, 5, rules arrowHead)
        ==> concat [ "M-N-M+N+M+N+M-N-M-N+M+N-M-N-M-N+M+N-M-N-M+N+M+N+M-N-M+N+"
                   , "M+N-M-N-M-N+M+N+M-N-M+N+M+N+M-N-M+N+M+N-M-N-M-N+M+N+M-N-"
                   , "M+N+M+N+M-N-M-N+M+N-M-N-M-N+M+N-M-N-M+N+M+N+M-N-M-N+M+N-"
                   , "M-N-M-N+M+N+M-N-M+N+M+N+M-N-M+N+M+N-M-N-M-N+M+N-M-N-M+N+"
                   , "M+N+M-N-M-N+M+N-M-N-M-N+M+N-M-N-M+N+M+N+M-N-M-N+M+N-M-N-"
                   , "M-N+M+N+M-N-M+N+M+N+M-N-M+N+M+N-M-N-M-N+M+N-M-N-M+N+M+N+"
                   , "M-N-M-N+M+N-M-N-M-N+M+N-M-N-M+N+M+N+M-N-M+N+M+N-M-N-M-N+"
                   , "M+N+M-N-M+N+M+N+M-N-M+N+M+N-M-N-M-N+M+N+M-N-M+N+M+N+M-N-"
                   , "M-N+M+N-M-N-M-N+M+N-M-N-M+N+M+N+M-N-M"
                   ]
    , (axiom dragon, 0, rules dragon)
        ==> "MX"
    , (axiom dragon, 1, rules dragon)
        ==> "A+MX--MY+"
    , (axiom cross, 1, rules cross)
        ==> "M-M+M+MM-M-M+M-M-M+M+MM-M-M+M-M-M+M+MM-M-M+M-M-M+M+MM-M-M+M"
    , (axiom peanoGosper, 1, rules peanoGosper)
        ==> "M+N++N-M--MM-N+"
    , (axiom peanoGosper, 2, rules peanoGosper)
        ==> concat [ "M+N++N-M--MM-N++-M+NN++N+M--M-N++-M+NN++N+M--M-N-M+N++N-"
                   , "M--MM-N+--M+N++N-M--MM-N+M+N++N-M--MM-N+--M+NN++N+M--M-N+"
                   ]
    , (axiom bush, 1, rules bush)
        ==> "M-[[X]+X]+M[+MX]-X"
    , (axiom tree, 1, rules tree)
        ==> "N[-M][+M][NM]"
    , (axiom dragon, 5, rules dragon)
        ==> concat [ "A+A+A+A+A+MX--MY+--A-MX++MY-+--A-A+MX--MY+++A-MX++MY--+"
                   , "--A-A+A+MX--MY+--A-MX++MY-+++A-A+MX--MY+++A-MX++MY---+-"
                   , "-A-A+A+A+MX--MY+--A-MX++MY-+--A-A+MX--MY+++A-MX++MY--++"
                   , "+A-A+A+MX--MY+--A-MX++MY-+++A-A+MX--MY+++A-MX++MY----+"
                   ]
    ]

moveTestCases
  = [ ('L', 90, ((100, 100), 90)) ==> ((100.0,100.0),180.0)
    , ('R', 90, ((100, 100), 90)) ==> ((100.0,100.0),0.0)
    , ('F', 90, ((100, 100), 90)) ==> ((100.0,101.0),90.0)
    , ('L', 60, ((50,50), 60))    ==> ((50,50),120.0)
    , ('R', 60, ((50,50), 60))    ==> ((50,50),0.0)
    , ('F', 60, ((50,50), 60))    ==> ((50.5,50.866024),60.0)
    , ('F', 45, ((-25,180),180))  ==> ((-26.0,180.0),180.0)
    , ('L', 45, ((-25,180),180))  ==> ((-25.0,180.0),225.0)
    , ('R', 45, ((-25,180),180))  ==> ((-25.0,180.0),135.0)
    , ('R', 90, ((-25,180),180))  ==> ((-25.0,180.0),90.0)
    ]

traceTestCases
  = [ ((expandOne (expand (axiom triangle) 1 (rules triangle)) commandMap),
      (angle triangle), blue)
      ==> sort [ ((0.0,0.0),(1.0,0.0),(0.0,0.0,1.0))
               , ((1.0,0.0),(0.99999994,1.0),(0.0,0.0,1.0))
               , ((0.99999994,1.0),(2.0,1.0),(0.0,0.0,1.0))
               , ((2.0,1.0),(2.0,0.0),(0.0,0.0,1.0))
               , ((2.0,0.0),(3.0,0.0),(0.0,0.0,1.0))
               ],
       ((expandOne (expand (axiom tree) 1 (rules tree)) commandMap),
       (angle tree), red)
      ==> sort [ ((0.0,0.0),(-4.371139e-8,1.0),(1.0,0.0,0.0))
                ,((-4.371139e-8,1.0),(0.7071067,1.7071068),(1.0,0.0,0.0))
                ,((-4.371139e-8,1.0),(-0.7071068,1.7071068),(1.0,0.0,0.0))
                ,((-4.371139e-8,1.0),(-8.742278e-8,2.0),(1.0,0.0,0.0))
                ,((-8.742278e-8,2.0),(-1.3113416e-7,3.0),(1.0,0.0,0.0))]
    ]


allTestCases
  = [ TestCase "angle"      (angle . unId)
                            (map mkId angleTestCases)
    , TestCase "axiom"      (axiom . unId)
                            (map mkId axiomTestCases)
    , TestCase "rules"      (rules . unId)
                            (map mkId rulesTestCases)
    , TestCase "lookupChar" (uncurry lookupChar)
                            lookupCharTestCases
    , TestCase "expandOne"  (uncurry expandOne)
                            expandOneTestCases
    , TestCase "expand"     (uncurry3 expand)
                            expandTestCases
    , TestCase "move"       (uncurry3 move)
                            moveTestCases
    , TestCase "trace1"     (sort . (uncurry3 trace1))
                            traceTestCases
    , TestCase "trace2"     (sort . (uncurry3 trace2))
                            traceTestCases
    ]

runTests = mapM_ goTest allTestCases

main = runTests
