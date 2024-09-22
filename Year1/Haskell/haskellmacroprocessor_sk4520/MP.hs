module MP where

import System.Environment
import Data.List

type FileContents = String

type Keyword      = String
type KeywordValue = String
type KeywordDefs  = [(Keyword, KeywordValue)]

separators :: String
separators
  = " \n\t.,:;!\"\'()<>/\\"

-----------------------------------------------------
-- This function compares a string s to the fst of the first pair
-- of the list of string/item pairs, and then recursively checks the tail. 
lookUp :: String -> [(String, a)] -> [a]
lookUp s [] = []
lookUp s (y : ys)
  | s == a    = b : lookUp s ys
  | otherwise = lookUp s ys
    where
      (a, b) = y

lookUpListComp :: String -> [(String, a)] -> [a]
lookUpListComp s kv
  = [ a | (x,a) <- kv, x == s]

lookUpHigherOrder :: String -> [(String, a)] -> [a]
lookUpHigherOrder a b
  = map snd (filter (\(x,y) -> x == a) b) 
-- This function splits a string given a list of separators.
-- Returns a pair of a list of separators and a list of words in a string.
-- It is done recursively by checking if the first character is a separator.
splitText :: [Char] -> String -> (String, [String])
splitText sp [] = ("", [""])
splitText sp (x : xs)
  | x `elem` sp = (x : sep, "" : wrs) 
  | otherwise   = (sep, addf wrs x)  
    where 
      (sep, wrs) = splitText sp xs
      -- Function addf adds the given char to the front of the first string
      -- of the given list of strings. 
      addf :: [String] -> Char -> [String]
      addf (w : wrs) x = (x : w) : wrs
   
-- Combines a string of separators and a list of strings.
-- Starts with the first element element of the list then appends a separator.
combine :: String -> [String] -> [String]
--combine [] [] 
 -- = []
combine [] (y : ys)  
  = y : [] : combine [] ys 
--combine (x : xs) [] 
 -- = [x] : combine xs []
combine (x : xs) (y : ys)
  = y : [x] : combine xs ys 

-- Gets keyword definitions by spliting lines of an info file.
getKeywordDefs :: [String] -> KeywordDefs
getKeywordDefs []
  = []
getKeywordDefs (x : xs)
  = (key, value) : getKeywordDefs xs
    where
      -- Returns a list of words separated by " " in x.
      (sep, (k : v)) = splitText " " x 
      key = k
      -- It concatenates a the tail of the list of words by inserting spaces.
      -- The string was split looking for " " so only spaces need to be added.
      value = concat(intersperse " " v)


{-

This is the code for expand function for a single set of keyword definitions.
I've decided to leave it as it is clearer than the extended version.

expand :: FileContents -> FileContents -> FileContents
expand txt inf
  = concat (combine sep (replaceDefs wrs))
    where
      (sep, wrs) = splitText separators txt
      (sp, lines) = splitText "\n" inf -- Splits info file into separate lines.
      def = getKeywordDefs lines
      -- This functions replaces matched keywords with their definitions.
      replaceDefs :: [String] -> [String]
      replaceDefs [] 
        = []
      replaceDefs (w : ws) 
        | lookUp w def == [] = w : replaceDefs ws
        | otherwise          = (head (lookUp w def)) : replaceDefs ws

-}

-- You may wish to uncomment and implement this helper function
-- when implementing expand
replaceWord :: String -> KeywordDefs -> String
replaceWord s df
  = replace m
    where
      m = (lookUp s df)
      replace :: [String] -> String
      replace [] 
        = s
      replace (m : ms) 
        = m 

-- This funcion expands a file according to all given sets of definitions.
-- It concatenates results by inserting "-----" and a new line between them.
expand :: FileContents -> FileContents -> FileContents
expand txt inf
  = concat (intersperse "-----\n" (expand' wrs infos))
    where
      (sep, wrs) = splitText separators txt
      (sep', infos) = splitText "#" inf -- Stlits info file into separate sets.
      expand' :: [String] -> [String] -> [String]
      expand' wrs [] 
        = []
      expand' wrs (i : is) 
        = (concat (combine sep (replaceDefs wrs))) : expand' wrs is
          where
            (sep'', line) = splitText "\n" i 
            def = getKeywordDefs line
            -- This functions replaces matched keywords with their definitions.
            replaceDefs :: [String] -> [String]
            replaceDefs [] 
              = []
            replaceDefs (w : ws) 
              = (replaceWord w def) : replaceDefs ws

---------------------------------------------
-- Reflection on the problem with separation:
--
-- In the project description it states, that three pieces of expanded text
-- should be separated by "-----" hence no separation after the last piece.
-- Although it is inconsistent with the example in the pdf file (there is -----)
-- If there were separators after the last line, then expand fails test cases.
-- So I decided not to include the separation after the last piece of text.
        
-----------------------------------------------------

-- The provided main program which uses your functions to merge a
-- template and source file.
main :: IO ()
main = do
  args <- getArgs
  main' args

  where
    main' :: [String] -> IO ()
    main' [template, source, output] = do
      t <- readFile template
      i <- readFile source
      writeFile output (expand t i)
    main' _ = putStrLn ("Usage: runghc MP <template> <info> <output>")
