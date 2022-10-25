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

# Concrete syntax 

Follow the unit tests in [letarithexpr.ml](test/lwrarithexpr.ml) for the concrete syntax of the language. 
To run the tests, execute the following command from the project directory:
```
dune test
```
For example, the following is a syntactically correct expression:
```
let x = 0 in let y = succ(x) in iszero(pred(let z = succ(y) in pred(pred(succ(z)))))
```
You can check its AST via `dune utop src` as follows:
```ocaml
"iszero pred succ 0 and not iszero succ pred succ 0" |> ArithexprLib.Main.parse;;
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
