module LSystems where

import IC.Graphics

type Rule
  = (Char, String)

type Rules
  = [Rule]

type Angle
  = Float

type Axiom
  = String

type LSystem
  = (Angle, Axiom, Rules)

type Vertex
  = (Float, Float)

type TurtleState
  = (Vertex, Float)

type Command
  = Char

type Commands
  = [Command]

type Stack
  = [TurtleState]

type ColouredLine
  = (Vertex, Vertex, Colour)

----------------------------------------------------------
-- Functions for working with systems.

-- Returns the rotation angle for the given system.
angle :: LSystem -> Float
angle (a, ax, r)
  = a

-- Returns the axiom string for the given system.
axiom :: LSystem -> String
axiom (a, ax, r)
  = ax

-- Returns the set of rules for the given system.
rules :: LSystem -> Rules
rules (a, ax, r)
  = r

-- Return the binding for the given character in the list of rules
lookupChar :: Char -> Rules -> String
-- Pre: the character has a binding in the Rules list
-- Pre: the Rules list is not empty
lookupChar ch r
 = head [s | (c, s) <- r, c == ch]

-- Expand command string s once using rule table r
expandOne :: String -> Rules -> String
expandOne [] rs
  = []
expandOne (x : xs) rs 
  = (lookupChar x rs) ++ expandOne xs rs

-- Expand command string s n times using rule table r
expand :: String -> Int -> Rules -> String
expand s 0 rs
  = s 
expand s n rs
  = expand (expandOne s rs) (n - 1) rs

-- Move a turtle
move :: Command -> Angle -> TurtleState -> TurtleState
--Pre: can only be 'L', 'R' or 'F'
move c a (pos, an)
 | c == 'L' = (pos, an + a)
 | c == 'R' = (pos, an - a)
 | c == 'F' = (pos', an)
   where
     an' = (an / 180) * pi 
     (x, y) = pos
     pos' = (x', y')
     -- The new coordinates are calculated using trigonometry.
     x' = x + (cos an')
     y' = y + (sin an')

--
-- Trace lines drawn by a turtle using the given colour, following the
-- commands in `cs' and assuming the given angle of rotation.
--
trace1 cm an cl 
  = fst(trace1' cm ((0,0), 90)) 
    where
    trace1' :: Commands -> TurtleState -> ([ColouredLine], Commands)
    trace1' [] ts = ([], [])
    trace1' (c : cs) ts
     | c == ']'  = ([], cs)
     | c == '['  = (t2 ++ t3, cs3) 
     | c == 'F'  = (line : t1, cs1) -- Line is drawn, when turtle moves forward.
     | otherwise = (t1, cs1)        -- When turtle turns, no line is traced.
       where 
         -- t1 represents defalut case when no '[/]' are encountered.
         (t1, cs1) = trace1' cs ts'
         -- t2 represents the line drawn by commands after a '['. 
         (t2, cs2) = trace1' cs ts
         -- t3 represents the line drawn by commands remaining after a ']'. 
         (t3, cs3) = trace1' cs2 ts
         -- line is defined by two turtle states.
         line = (pos, pos', cl)
         (pos, ang) = ts
         (pos', ang') = ts'
         ts' = move c an ts

trace2 :: Commands -> Angle -> Colour -> [ColouredLine]
trace2 cm an cl
  = trace2' cm ((0,0), 90) []
    where
      trace2' :: Commands -> TurtleState -> [TurtleState] -> [ColouredLine] 
      trace2' [] t ts
        = []
      trace2' (c : cs) t ts
        | c == '['  = trace2' cs t (t : ts) -- t is pushed on top of the stack. 
        | c == ']'  = trace2' cs t'' (ts')
        | c == 'F'  = line : trace2' cs t' ts  
        | otherwise = trace2' cs t' ts -- When turtle turns, no line is traced.
          where
            (t'' : ts') = ts -- When c==']', previous state is popped from ts.
            -- When c == 'F' a line is traced between two turtle states.
            line = (pos, pos', cl)
            t' = move c an t
            (pos', ang') = t'
            (pos, ang) = t

----------------------------------------------------------
-- Some given functions

expandLSystem :: LSystem -> Int -> String
expandLSystem (_, axiom, rs) n
  = expandOne (expand axiom n rs) commandMap

drawLSystem1 :: LSystem -> Int -> Colour -> IO ()
drawLSystem1 system n colour
  = drawLines (trace1 (expandLSystem system n) (angle system) colour)

drawLSystem2 :: LSystem -> Int -> Colour -> IO ()
drawLSystem2 system n colour
  = drawLines (trace2 (expandLSystem system n) (angle system) colour)

------------------ Extensions ----------------------------
-- This function turns the colour to green whenever trace enters a new branch.
traceC :: Commands -> Angle -> Colour -> [ColouredLine]
traceC cm an cl
  = traceC' cm cl ((0,0), 90) []
    where
      traceC' :: Commands->Colour->TurtleState->[TurtleState]->[ColouredLine] 
      -- There are no spaces between the type names since it didn't fit 80.
      traceC' [] cli t ts
        = []
      traceC' (c : cs) cli t ts
        | c == '['  = traceC' cs cl' t (t : ts) 
        | c == ']'  = traceC' cs cl t'' (ts')
        | c == 'F'  = line : traceC' cs cli t' ts  
        | otherwise = traceC' cs cli t' ts 
          where
            (t'' : ts') = ts 
            line = (pos, pos', cli)
            t' = move c an t
            (pos', ang') = t'
            (pos, ang) = t 
            -- When a new branch is opened, the line changes colour
            cl' = change cli
            change :: Colour -> Colour
            change c
              = green

drawLSystemC :: LSystem -> Int -> Colour -> IO ()
drawLSystemC system n colour
  = drawLines (traceC (expandLSystem system n) (angle system) colour)


----------------------------------------------------------
-- Some test systems.

unwind, cross, triangle, arrowHead, peanoGosper :: LSystem
dragon, snowflake, tree, bush :: LSystem

cross
  = (90,
     "M-M-M-M",
     [('M', "M-M+M+MM-M-M+M"),
      ('+', "+"),
      ('-', "-")
     ]
    )

triangle
  = (90,
     "-M",
     [('M', "M+M-M-M+M"),
      ('+', "+"),
      ('-', "-")
     ]
    )

arrowHead
  = (60,
     "N",
     [('M', "N+M+N"),
      ('N', "M-N-M"),
      ('+', "+"),
      ('-', "-")
     ]
    )

peanoGosper
  = (60,
     "M",
     [('M', "M+N++N-M--MM-N+"),
      ('N', "-M+NN++N+M--M-N"),
      ('+', "+"),
      ('-', "-")
     ]
    )

dragon
  = (45,
     "MX",
     [('M', "A"),
      ('X', "+MX--MY+"),
      ('Y', "-MX++MY-"),
      ('A', "A"),
      ('+', "+"),
      ('-', "-")
     ]
    )

snowflake
  = (60,
     "M--M--M",
     [('M', "M+M--M+M"),
      ('+', "+"),
      ('-', "-")
     ]
    )

tree
  = (45,
     "M",
     [('M', "N[-M][+M][NM]"),
      ('N', "NN"),
      ('[', "["),
      (']', "]"),
      ('+', "+"),
      ('-', "-")
     ]
    )

bush
  = (22.5,
     "X",
     [('X', "M-[[X]+X]+M[+MX]-X"),
      ('M', "MM"),
      ('[', "["),
      (']', "]"),
      ('+', "+"),
      ('-', "-")
     ]
    )
-- I have added my own LSystem that draws a plant-like structure. 
unwind
 = (90,
    "M+M-",
    [('M', "M+M-"),
     ('+', "+"),
     ('-', "-")
    ]
   )

    

commandMap :: Rules
commandMap
  = [('M', "F"),
     ('N', "F"),
     ('X', ""),
     ('Y', ""),
     ('A', ""),
     ('[', "["),
     (']', "]"),
     ('+', "L"),
     ('-', "R")
    ]
