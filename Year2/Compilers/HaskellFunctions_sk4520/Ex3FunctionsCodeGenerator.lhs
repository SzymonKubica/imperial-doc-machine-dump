> module Ex3FunctionsCodeGenerator where
> import Ex3FunctionsTypes
> import Data.List

-----------------------------------------------------------
Solution for Compilers exercise 3

Paul Kelly  Imperial College London  2009
-----------------------------------------------------------

Fill in the gaps...

Part (1): translate function declaration

> transFunction :: Function -> [Instr]
> transFunction (Defun fname paramname body)
>  = [Define fname] ++ transExp body allRegs

Part (2): saving registers

> saveRegs :: [Register] -> [Instr]
> saveRegs regsNotInUse
>  = [Mov (Reg r) Push | r <- allRegs \\ regsNotInUse]

> restoreRegs regsNotInUse
>  = [Mov Pop (Reg r) | r <- allRegs \\ regsNotInUse]


Part (3): translate expression (ie function body, perhaps including
function calls)

> transExp :: Exp -> [Register] -> [Instr]
> 
> transExp (Const x) (dst:rest) = [Mov (ImmNum x)(Reg dst)]
> transExp (Var x) (dst:rest) = [Mov (Reg D1)(Reg dst)]



> weight (Const x) = 1


