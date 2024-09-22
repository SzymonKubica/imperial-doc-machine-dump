data Statement = Assign Name Expression |
                 Compound [Statement] |
                 IfThen Expression Statement |
                 IfThenElse Expression Statement Statement |
                 While Expression Statement

data Instruction = 
  Add | Sub | Mul | Div
  | PushImm num
  | PushAbs Name
  | Pop name
  | CompEq
  | JTrue label
  | JFalse label
  | Jump label
  | Define label

translate_statement :: Statement -> [Instruction]
translate_statement (Assign var exp)
 = transExpr exp ++ [Pop var]

translate_statement (Compound [statement : statements])
 = translate_statement (statement) ++ 
   translate_statement (Compund statements)

translate_statement (Compound [statement])
 = translate_statement (statement) 

translate_statement (IfThen exp statement)
 = transExpr exp ++ 
   [JFalse label] ++ 
   translate_statement (statement) ++
   [Define label]
   where 
   label = some new label

translate_statement (IfThenElse exp statement1 statement2)
 = transExpr exp ++
   [JFalse label1] ++
   translate_statement (statement1) ++
   [Jump label2] ++
   [Define label1] ++
   translate_statement (statement2) ++
   [Define label2] 
   where
    label1 = some new label
    label2 = some different new label

translate_statement (While exp statement)
 = [Define start] ++
   transExpr exp ++
   [JFalse label1] ++
   translate_statement (statement) ++
   [Jump start] ++
   [Define label1] 
   where 
    label1 = some new label  
    start = some new different label


  
