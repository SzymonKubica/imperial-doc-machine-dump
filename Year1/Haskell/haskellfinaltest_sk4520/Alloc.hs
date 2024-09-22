module Alloc where

import Data.Maybe
import Data.List
import Data.Tuple

import Types
import Examples

------------------------------------------------------
--
-- Part I
--
count :: Eq a => a -> [a] -> Int
count a as
  = length [a' | a' <- as, a' == a] 

degrees :: Eq a => Graph a -> [(a, Int)]
degrees (ns, es)  
  = map countEs ns   
  where 
    countEs n
      = (n, count n (map fst es) + count n (map snd es))
  

neighbours :: Eq a => a -> Graph a -> [a]
neighbours n (_, es)
  = map snd [e | e <- es, (fst e) == n] ++ map fst [e | e <- es, (snd e) == n]   

removeNode :: Eq a => a -> Graph a -> Graph a
removeNode n (ns, es) 
  = ([n' | n' <- ns, n' /= n], [e | e <- es, fst e /= n , snd e /= n]) 

------------------------------------------------------
--
-- Part II
--
colourGraph :: (Ord a, Show a) => Int -> Graph a -> Colouring a
colourGraph i ([], [])
  = []
colourGraph i g
  = (n, c) : colourGraph i g'
  where
    n = snd (minimum (map swap (degrees g)))
    g' = removeNode n g
    n'colours = [lookUp n' (colourGraph i g') | n' <- neighbours n g]
    possibleCs = [1 .. i] \\ n'colours
    c = if (possibleCs == []) then 0 else minimum possibleCs



------------------------------------------------------
--
-- Part III
--
buildIdMap :: Colouring Id -> IdMap
buildIdMap cl 
  = ("return","return") : map buildId cl
  where
    buildId :: (Id, Colour) -> (Id, Id)
    buildId (v, 0) = (v, v)
    buildId (v, n) = (v, 'R' : show n)

buildArgAssignments :: [Id] -> IdMap -> [Statement]
buildArgAssignments ids m 
  = [(Assign (lookUp x m) (Var x)) | x <- ids]  

renameExp :: Exp -> IdMap -> Exp
renameExp (Var v) m
  | v `elem` (map fst m) = Var (lookUp v m) 
renameExp (Apply op e1 e2) m
  = Apply op (renameExp e1 m) (renameExp e2 m)
renameExp e m 
  = e

renameBlock :: Block -> IdMap -> Block
renameBlock b m 
  = (map renameS b)\\[(Assign v (Var v)) | v <- (map snd m)]
  where
    renameS :: Statement -> Statement  
    renameS (Assign v e)
      = Assign (lookUp v m) (renameExp e m)
    renameS (If e b1 b2) 
      = If (renameExp e m) (renameBlock b1 m) (renameBlock b2 m)
    renameS (While e b) 
      = While (renameExp e m) (renameBlock b m)
     

renameFun :: Function -> IdMap -> Function
renameFun (f, as, b) idMap
  = (f, as, buildArgAssignments as idMap ++ renameBlock b idMap)

-----------------------------------------------------
--
-- Part IV
--
buildIG :: [[Id]] -> IG
buildIG  
  = undefined 

-----------------------------------------------------
--
-- Part V
--
liveVars :: CFG -> [[Id]]
liveVars 
  = undefined

buildCFG :: Function -> CFG
buildCFG 
  = undefined
