module Tests where

import IC.TestSuite

import Sequences

-- Added some more cases to test each of functions more thoroughly.
maxOf2TestCases
  = [ (1, 2) ==> 2,
      (2, 1) ==> 2,
      (2, 2) ==> 2,
      (3, 4) ==> 4
    ]

maxOf3TestCases
  = [ (1, 2, 3) ==> 3,
      (2, 1, 3) ==> 3,
      (3, 3, 3) ==> 3,
      (3, 1, 3) ==> 3
    ]

isADigitTestCases
  = [ ('1') ==> True,
      ('A') ==> False,
      ('z') ==> False
    ]

isAlphaTestCases
  = [ ('1') ==> False,
      ('A') ==> True,
      ('b') ==> True
    ]

digitToIntTestCases
  = [ ('0') ==> 0,
      ('9') ==> 9,
      ('7') ==> 7
    ]

toUpperTestCases
  = [ ('a') ==> 'A',
      ('A') ==> 'A',
      ('b') ==> 'B'
    ]

--
-- Sequences and series
--

arithmeticSeqTestCases
  = [ (0.0, 10.0, 0) ==> 0.0,
      (10.0, 10.0, 0) ==> 10.0,
      (0.0, 10.0, 10) ==> 100.0,
      (10.0, 0.0, 10) ==> 10.0
    ]
--Added test cases that are not trivial as well as some for fractional common ratios.
geometricSeqTestCases
  = [ (0.0, 10.0, 0) ==> 0.0,
      (10.0, 10.0, 0) ==> 10.0,
      (0.0, 10.0, 10) ==> 0.0,
      (5.0, 1.0, 10) ==> 5.0,
      (5.0, 2.0, 4) ==> 80.0,
      (10.0, 0.5, 2) ==> 2.5,
      (10.0, 0.0, 10) ==> 0.0
    ]

arithmeticSeriesTestCases
  = [ (0.0, 10.0, 0) ==> 0.0,
      (10.0, 10.0, 0) ==> 10.0,
      (0.0, 10.0, 10) ==> 550.0,
      (10.0, 0.0, 10) ==> 110.0
    ]

geometricSeriesTestCases
  = [ (0.0, 10.0, 0) ==> 0.0,
      (10.0, 10.0, 0) ==> 10.0,
      (10.0, 0.5, 2) ==> 17.5,
      (0.0, 10.0, 10) ==> 0.0,
      (4.0, (-1.0), 10) ==> 4.0,
      (4.0, (-1.0), 9) ==> 0.0,
      (10.0, 0.0, 10) ==> 10.0
    ]

-- You can add your own test cases above

sequencesTestCases
  = [ TestCase  "maxOf2"      (uncurry maxOf2)
                              maxOf2TestCases
     , TestCase "maxOf3"      (uncurry3 maxOf3)
                              maxOf3TestCases
     , TestCase "isADigit"    (isADigit)
                              isADigitTestCases
     , TestCase "isAlpha"     (isAlpha)
                              isAlphaTestCases
     , TestCase "digitToInt"  (digitToInt)
                              digitToIntTestCases
     , TestCase "toUpper"     (toUpper)
                              toUpperTestCases
     , TestCase "arithmeticSeq" (uncurry3 arithmeticSeq)
                                arithmeticSeqTestCases
     , TestCase "geometricSeq"  (uncurry3 geometricSeq)
                                geometricSeqTestCases
     , TestCase "arithmeticSeries"  (uncurry3 arithmeticSeries)
                                    arithmeticSeriesTestCases
     , TestCase "geometricSeries"   (uncurry3 geometricSeries)
                                    geometricSeriesTestCases
    ]

runTests = mapM_ goTest sequencesTestCases

main = runTests
