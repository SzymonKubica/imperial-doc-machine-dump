module Tests (Tests.main) where
import IC.TestSuite
import TicTacToe hiding (main)


gameOverTestCases
   = [ testBoard1 ==> True
     , testBoard2 ==> False
     , testBoard3 ==> True
     ]

parsePositionTestCases
   = [
       ("0 2") ==> (Just (0,2))
     , ("0 -8") ==> (Just (0,-8))
     , ("10 -28") ==> (Just (10,-28))
     , ("-4 1") ==> (Just (-4,1))
     , ("-4 1") ==> (Just (-4,1))
     , ("-6 18") ==> (Just (-6,18))
     , ("0 %1") ==> (Nothing)
     , ("") ==> (Nothing)
     , ("10 -") ==> (Nothing)
     , ("1 2 3") ==> (Nothing)
     ]

tryMoveTestCases
  = [
      (X,(0,0),testBoard2) ==> (Nothing)
    , (O,(-1,2),testBoard2) ==> (Nothing)
    , (O,(0,-1),testBoard2) ==> (Nothing)
    , (O,(-3,2),testBoard3) ==> (Nothing)
    , (O,(0,1),testBoard3) ==> (Nothing)
    , (O,(5,1),testBoard3) ==> (Nothing)
    , (O,(2,2),testBoard3) ==> (Nothing)
    , (O,(3,1),testBoard3) ==> (Nothing)
    , (O,(1,1),testBoard2) ==> (Just ([Taken X,Empty,Empty,Taken O],2))
    , (O,(3,3),testBoard1) ==> (Just ([Taken O,Taken X,Empty,Taken O,Taken O,
                                Empty,Taken X,Taken X,Taken O,Empty,Empty,Taken
                                X,Taken O,Taken X,Empty,Taken O],4))
    ]

-- You can add your own test cases above

allTestCases
  = [
      TestCase "gameOver" (gameOver)
               gameOverTestCases
    , TestCase "parsePosition" (parsePosition)
               parsePositionTestCases
    , TestCase "tryMove" (uncurry3 tryMove)
               tryMoveTestCases
    ]


runTests = mapM_ goTest allTestCases

main = runTests
