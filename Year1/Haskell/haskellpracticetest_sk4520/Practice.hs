module Practice where
import Data.List
import Data.Maybe

isPrefix :: String -> String -> Bool
isPrefix "" str
  = True 
isPrefix (p : ps) ""
  = False
isPrefix (p : ps) (s : str)
  = p == s && isPrefix ps str

removePrefix :: String -> String -> String
--Pre: The first string is a prefix of the second.
removePrefix "" str
  = str
removePrefix (p : ps) (s : str) 
  = removePrefix ps str

suffixes :: [a] -> [[a]]
suffixes as 
  = take (length as) (iterate (drop 1) as)

isSubstring :: String -> String -> Bool
isSubstring s str
  = any (isPrefix s) (suffixes str)

findSubstrings :: String -> String -> [Int]
findSubstrings s str
  =  checkSuffs s (suffixes str) 
    where
      checkSuffs :: String -> [String] -> [Int]
      checkSuffs sub []   = []
      checkSuffs sub (s : suffs) 
        | isPrefix sub s  = index : checkSuffs sub suffs  
        | otherwise          = checkSuffs sub suffs
        where 
          -- Pre: the s is always an element of suffixes str, hence elem index
          -- will never yield Nothing, thus default 0 will never be reached.
          index = (fromMaybe 0 (elemIndex s (suffixes str))) 
      
findSubstrings' :: String -> String -> [Int]
findSubstrings' s str
  = [ (fromMaybe 0 (elemIndex suff (suffixes str))) |  suff <- (suffixes str), isPrefix s suff]
