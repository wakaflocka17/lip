# Arithmetic expressions with let bindings

```ocaml
type expr =
    True
  | False
  | Not of expr
  | And of expr * expr
  | Or of expr * expr
  | If of expr * expr * expr
  | Zero
  | Succ of expr
  | Pred of expr
  | IsZero of expr
  | Var of string     
  | Let of string * expr * expr
```

## Big-step semantics

```ocaml
-------------------------------------- [B-Var]
<x,rho> => rho x

<e1,rho> => v1   <e2,rho{v1/x}> => v2
-------------------------------------- [B-Let]
<let x=e1 in e2,rho> => v2
```

## Small-step semantics

```ocaml

---------------------------------- [S-LetV]
let x=v1 in e2 -> e2[x->v1]

e1 -> e1'
---------------------------------- [S-Let]
let x=e1 in e2 -> let x=e1' in e2
```

```ocaml
let x = 0 in let y = succ(x) in iszero(pred(let z = succ(y) in pred(pred(succ(z)))))
 -> let y = succ(0) in iszero(pred(let z = succ(y) in pred(pred(succ(z)))))
 -> iszero(pred(let z = succ(succ(0)) in pred(pred(succ(z)))))
 -> iszero(pred(pred(pred(succ(succ(succ(0)))))))
 -> iszero(pred(pred(succ(succ(0)))))
 -> iszero(pred(succ(0)))
 -> iszero(0)
 -> true
 ```
