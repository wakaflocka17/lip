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
------------------------------ [B-Var]
<x,rho> => rho x

<e1,rho> => v1   <e2,rho{v1/x}> => v2
------------------------------------- [B-Let]
<let x = e1 in e2,rho> => v2
```

## Small-step semantics

```ocaml

------------------------------ [S-LetV]
let x = v1 in e2 -> e2[x->v1]
```
