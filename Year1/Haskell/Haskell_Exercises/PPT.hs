import Data.List
import System.IO
import Data.Time.Clock.POSIX
ourConcatMap :: (a -> [b]) -> [a] -> [b]
-- Nice point free notation.
ourConcatMap f 
  = (concat . map (f)) 

ourIterate :: (a -> a) -> a -> [a]
ourIterate f x
  = x : (map f (ourIterate f x))

ourScanL :: (a -> b -> a) -> a -> [b] -> [a]
ourScanL f e
  = map (foldl f e) . (inits)

ourScanR ::  (a -> b -> b) -> b -> [a] -> [b]
ourScanR f u 
  = map (foldr  f u ) . tails 

powerOf :: Integer -> [Integer]
powerOf n
  = iterate (n*) 1

maxOfAllSeenSoFar :: [Integer] -> [Integer]
maxOfAllSeenSoFar xs  
  = map (maximum) (drop 1 (inits xs)) 

maxOfMinsSeenSoFar :: [Integer] -> [Integer] -> [Integer]
maxOfMinsSeenSoFar as bs
  = maxOfAllSeenSoFar (zipWith (min) as bs)

rand :: Integer -> Integer -> Integer
rand n max
  = (n * 37) `mod` max 

--randList :: Integer -> Integer
--randList max
--  = 

pseudoRandom :: Integer -> IO ()
pseudoRandom max
  = do 
      seed <- (round . (*1000)) <$> getPOSIXTime
      putStrLn (show (rand seed max))
