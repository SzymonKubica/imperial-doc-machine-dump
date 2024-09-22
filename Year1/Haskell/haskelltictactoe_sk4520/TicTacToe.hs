module TicTacToe where

import Data.Char
import Data.Maybe
import Data.List
import Text.Read


-------------------------------------------------------------------
data Player = O | X
            deriving (Eq, Show)

data Cell = Empty | Taken Player
          deriving (Eq, Show)

type Board = ([Cell], Int)

type Position = (Int, Int)

-------------------------------------------------------------------

--
-- Some useful functions from, or based on, the unassessed problem sheets...
--

-- Preserves Just x iff x satisfies the given predicate. In all other cases
-- (including Nothing) it returns Nothing.
filterMaybe :: (a -> Bool) -> Maybe a -> Maybe a
filterMaybe p m@(Just x)
  | p x = m
filterMaybe p _
  = Nothing

-- Replace nth element of a list with a given item.
replace :: Int -> a -> [a] -> [a]
replace 0 p (c : cs)
  = p : cs
replace _ p []
  = []
replace n p (c : cs)
  = c : replace (n - 1) p cs

-- Returns the rows of a given board.
rows :: Board -> [[Cell]]
rows (cs , n)
  = rows' cs
  where
    rows' []
      = []
    rows' cs
      = r : rows' rs
      where
        (r, rs) = splitAt n cs

-- Returns the columns of a given board.
cols :: Board -> [[Cell]]
cols
  = transpose . rows

-- Returns the diagonals of a given board.
diags :: Board -> [[Cell]]
diags (cs, n)
  = map (map (cs !!)) [[k * (n + 1) | k <- [0 .. n - 1]],
                      [k * (n - 1) | k <- [1 .. n]]]

-------------------------------------------------------------------
-- The game is over if either of the three tests succeeds. 

gameOver :: Board -> Bool
gameOver b
  = (check . rows) b || ((check . cols) b) || (check . diags) b   
    where 
      check :: [[Cell]] -> Bool
      check []
        = False
      check (x : xs)
        = and(map(==(Taken O)) x) || and(map(==(Taken X)) x) || check xs

-------------------------------------------------------------------

--
-- Moves must be of the form "row col" where row and col are integers
-- separated by whitespace. Bounds checking happens in tryMove, not here.
-- The length of the list of numbers needs to be two, otherwise it fails test.
-- I would personally make it more flexible and allow string "a b c d ... z" 
-- to be interpreted as (a, b), but it fails default test "1 2 3" so the length
-- of the list of ints needs to be checked. 
--
parsePosition :: String -> Maybe Position
parsePosition pos
  | (length numList) /= 2 = Nothing -- we can omit this if we allow "a b c .."
  | otherwise             = do
                              x <- readMaybe x' :: Maybe Int  
                              y <- readMaybe y' :: Maybe Int  
                              return (x, y)
    where 
    (x' : y' : rem) = numList
    numList = splitOn ' ' pos []
    --splitOn adds characters to acc. parameter and adds it to the list on " ".
    splitOn :: Char -> String -> String -> [String]
    splitOn sep [] acc
      = acc : []
    splitOn sep (x : xs) acc 
      | x == sep  = acc : splitOn sep xs []
      | otherwise = splitOn sep xs (acc ++ [x])

tryMove :: Player -> Position -> Board -> Maybe Board
tryMove p (i, j) (cells, n)
  | outOfBounds index = Nothing
  | isTaken index     = Nothing
  | otherwise         = Just (cells', n)
    where
      index = (i * n + j)
      cells' = replace index (Taken p) cells
      -- This function reduces the number of guards needed.
      isTaken :: Int -> Bool
      isTaken x = (cells !! x == (Taken O)) || (cells !! x == (Taken X))
      -- This function makes the first guard easier to read.
      outOfBounds :: Int -> Bool
      outOfBounds x =  (x >= n ^ 2) || (x < 0)

-------------------------------------------------------------------
-- I/O Functions

prettyPrint :: Board -> IO ()
prettyPrint b
  = do
      putStrLn ("\n" ++ hLine) 
      putStrLn (intercalateCol rs'')
      putStrLn (hLine ++ "\n") 
      where
        rs = rows b
        rs' = map (map display) rs 
        rs'' = map intercalateRow rs'
        display :: Cell -> String
        display Empty     = "   "
        display (Taken p) = " " ++ show p ++ " "
        (_ , n) = b
        hLine = "|" ++ makeHLine (4 * n - 1 ) ++ "|" 
        --This function prints a horizontal line between rows
        makeHLine :: Int -> String
        makeHLine 0
          = []
        makeHLine n 
          | n `mod` 4 == 0 = '|' : makeHLine (n - 1)
          | otherwise  = '-' : makeHLine (n - 1)
        --This functions ensure that outside borders are also printed.
        intercalateRow :: [String] -> String
        intercalateRow s = "|" ++ intercalate ("|") s ++ "|"

        intercalateCol :: [String] -> String
        intercalateCol s =intercalate ("\n" ++ hLine ++ "\n") s
        
-- The following reflect the suggested structure, but you can manage the game
-- in any way you see fit.

-- Repeatedly read a target board position and invoke tryMove until
-- the move is successful (Just ...).
takeTurn :: Board -> Player -> IO Board
takeTurn b p 
  = do
      putStrLn ("\nNow player " ++ (show p) ++ " takes turn.\n")
      putStrLn "Enter a string of type 'row col' specifying your next move."
      putStrLn "Note that indexing in the table starts at 0."
      pos <- getLine
      if (canMove pos) 
        then do
               return (fromJust(tryMove p (fromJust(parsePosition pos)) b))
        else do 
               putStrLn "Position you entered is not valid, please try again."
               takeTurn b p
    where
      canMove :: String -> Bool
      canMove pos
        = (pos' /= Nothing) && ((tryMove p (fromJust pos') b) /= Nothing)
          where
            pos' = parsePosition pos

-- Manage a game by repeatedly: 1. printing the current board, 2. using
-- takeTurn to return a modified board, 3. checking if the game is over,
-- printing the board and a suitable congratulatory message to the winner
-- if so.
playGame :: Board -> Player -> IO ()
playGame b p
  = do 
      prettyPrint b
      b' <- takeTurn b p
      if (gameOver b')
        then do
               prettyPrint b'
               putStr ("\nPlayer " ++ (show p) ++ " won. Congratulations!!!\n")
        else do
               if (p == X) 
                 then do playGame b' O
                 else do playGame b' X


-- Print a welcome message, read the board dimension, invoke playGame and
-- exit with a suitable message.
main :: IO ()
main
  = do
      putStrLn "\nWelcome to the TicTacToe game."
      putStrLn "------------------------------"
      putStr "Please, enter the dimension of the board:"
      d <- getLine 
      if ((readMaybe d :: Maybe Int) == Nothing) 
        then do 
               putStrLn "The dimension needs to be an integer"
               main 
        else do
               playGame (makeBoard (fromJust(readMaybe d :: Maybe Int))) X
               putStrLn "\nThe game finished, invoke 'main' to play again."
                
    where
      makeBoard :: Int -> Board
      makeBoard n
        = ((makeCells (n ^ 2)), n) 
        where
          makeCells :: Int -> [Cell]
          makeCells 0 
            = []
          makeCells n
            = Empty : makeCells (n - 1)

            
-------------------------------------------------------------------

testBoard1, testBoard2, testBoard3 :: Board

testBoard1
  = ([Taken O,Taken X,Empty,Taken O,
      Taken O,Empty,Taken X,Taken X,
      Taken O,Empty,Empty,Taken X,
      Taken O,Taken X,Empty,Empty],
      4)

testBoard2
  = ([Taken X,Empty,
      Empty,Empty],
      2)

testBoard3
  = ([Taken O,Taken X,Empty,Taken O,Taken X,
      Taken O,Empty,Taken X,Taken X,Empty,
      Empty,Empty,Taken X,Taken O,Taken O,
      Taken O,Taken X,Empty,Empty,Taken X,
      Taken X,Empty,Taken O,Empty,Empty],
      5)
