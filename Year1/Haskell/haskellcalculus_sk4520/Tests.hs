module Tests where

import IC.TestSuite hiding (Id)
import qualified IC.TestSuite as TS
import Calculus

-- Added a test for showExp function.
showExpTests
  = [ (UnApp Sin (UnApp Cos x))
        ==> "(sin(cos(x)))"

    , (UnApp Sin x)
        ==> "(sin(x))"
    , e1
        ==> "5.0*x"
    , e2
        ==> "((x^2+y)-7.0)" 
    , e3
        ==> "(x-y^2/(4.0*xy-y^2))"
    , e4
        ==> "(-(cos(x)))"
    , e5
        ==> "(sin(1.0+log(2.0*x)))"
    , e6
        ==> "(log(3.0*x^2+2.0))"
    , (UnApp Log (BinApp Mul (Val 3.0) (Id "x")))
        ==> "log(3.0*x)"
    , (UnApp Neg (BinApp Add (Val (-5)) (Id "t'")))
        ==> "(-(-5.0+t'))"
    ]

evalTests
  = [ ((Val 7),  [("x",380)])
        ==> 7.0

    , ((Id "a"), [("x",380), ("a",42), ("t",10)])
        ==> 42.0

    , ( (BinApp Add (Val (-5)) (Id "t'")), [("t",10), ("t'",18)])
        ==> 13.0

    , ((UnApp Neg (BinApp Add (Val (-5)) (Id "t'"))), [("t",10), ("t'",19)])
        ==> (-14.0)

    , ((BinApp Mul (Id "x") (Id "x")), [("t",10), ("t'",18.6), ("x",-55)])
        ==> 3025.0

    , ((BinApp Div (Val 3) (Id "z")), [("z",7)])
        ==> 0.42857142857142855

    , ((UnApp Neg (Id "x")), [("x",0.37)])
        ==> (-0.37)

    , ((UnApp Sin (Val 2.4)), [])
        ==> 0.675463180551151

    , ((UnApp Cos (Val 2.4)), [])
        ==> (-0.7373937155412454)

    , ( e1, [("x",0.37)])
        ==> (1.85)

    , ( e2, [("x",0.37), ("y", 8.2)])
        ==> 1.3369

    , ( e3, [("x",0.37), ("y", 2.0)])
        ==> 4.216153846153846

    , ( e4, [("x",0.37)])
        ==> (-0.9323273456060345)

    , ( e5, [("x",0.37)])
        ==> 0.6433720724587564

    , ( e6, [("x",0.37)])
        ==> 0.8799171617597958
    ]

diffTests
  = [ ((UnApp Sin (Id "x")), "x") ==> BinApp Mul (UnApp Cos (Id "x")) (Val 1.0)

    , ((UnApp Cos (Id "x")), "x") ==>
        UnApp Neg (BinApp Mul (UnApp Sin (Id "x")) (Val 1.0))
   
    , (e1, "x") ==>
        BinApp Add (BinApp Mul (Val 5.0) (Val 1.0)) (BinApp Mul (Val 0.0)
                                                                (Id "x"))

    , (e2, "x") ==>
        BinApp Add (BinApp Add (BinApp Add (BinApp Mul (Id "x") (Val 1.0))
                               (BinApp Mul (Val 1.0) (Id "x"))) (Val 0.0))
                   (UnApp Neg (Val 0.0))

    , (e2, "y") ==>
        BinApp Add (BinApp Add (BinApp Add (BinApp Mul (Id "x") (Val 0.0))
                               (BinApp Mul (Val 0.0) (Id "x"))) (Val 1.0))
                   (UnApp Neg (Val 0.0))
    , (e4, "x") ==>
        UnApp Neg (UnApp Neg (BinApp Mul (UnApp Sin (Id "x")) (Val 1.0)))

    , (e5, "x") ==>
        BinApp Mul (UnApp Cos (BinApp Add (Val 1.0)
                                          (UnApp Log (BinApp Mul (Val 2.0)
                                                                 (Id "x")))))
                   (BinApp Add (Val 0.0)
                               (BinApp Div (BinApp Add (BinApp Mul (Val 2.0)
                                                                   (Val 1.0))
                                            (BinApp Mul (Val 0.0) (Id "x")))
                           (BinApp Mul (Val 2.0) (Id "x"))))
    , (e6, "x") ==>
        BinApp Div (BinApp Add (BinApp Add (BinApp Mul (Val 3.0)
                                           (BinApp Add (BinApp Mul (Id "x")
                                                                   (Val 1.0))
                                                       (BinApp Mul (Val 1.0)
                                                                   (Id "x"))))
                                       (BinApp Mul (Val 0.0)
                                                   (BinApp Mul (Id "x")
                                                               (Id "x"))))
                                (Val 0.0))
                    (BinApp Add (BinApp Mul (Val 3.0) (BinApp Mul (Id "x")
                                                                  (Id "x")))
                                (Val 2.0))
    , ((BinApp Add (UnApp Log (Id "x")) (UnApp Cos (Id "y"))), "x") ==>
        BinApp Add (BinApp Div (Val 1.0) (Id "x")) (UnApp Neg (BinApp Mul 
                                                   (UnApp Sin (Id "y")) 
                                                              (Val 0.0)))
    , ((UnApp Log (UnApp Sin (UnApp Cos (Id "x")))), "x") ==>
       BinApp Div (BinApp Mul (UnApp Cos (UnApp Cos (Id "x"))) 
                                                    (UnApp Neg (BinApp Mul 
                                        (UnApp Sin (Id "x")) (Val 1.0)))) 
                                         (UnApp Sin (UnApp Cos (Id "x")))
    ]

maclaurinTests
  = [ (UnApp Sin (Id "x"), 2, 2) ==> 2.0
    , (UnApp Sin (Id "x"), 2, 3) ==> 2.0
    , (UnApp Sin (Id "x"), 2, 5) ==> 0.6666666666666667
    , (UnApp Sin (Id "x"), 2, 7) ==> 0.9333333333333333
    , (UnApp Sin (Id "x"), 2, 9) ==> 0.9079365079365079
    , (UnApp Cos (Id "x"), 4, 2) ==> 1.0
    , (UnApp Cos (Id "x"), 4, 3) ==> (-7.0)
    , (UnApp Cos (Id "x"), 4, 5) ==> 3.666666666666666
    , (UnApp Cos (Id "x"), 4, 7) ==> (-2.022222222222223) 
    , (UnApp Cos (Id "x"), 4, 9) ==> (-0.39682539682539764)
    ]

allTestCases
  = [ testCase "showExp" (showExp . unId)      (map mkId showExpTests)
    , testCase "diff"       (uncurry diff)       diffTests
    , floatTestCase "maclaurin"  (uncurry3 maclaurin) maclaurinTests
    , floatTestCase "eval"       (uncurry eval)       evalTests
    ]

runTests = mapM_ goTest allTestCases

main = runTests
