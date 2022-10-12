# A minimal language for boolean expressions

This is a step-by-step guide to create an interpreter for a small language of boolean expressions, with the following abstract syntax:
```ocaml
type boolExpr =
    True
  | False
  | If of boolExpr * boolExpr * boolExpr
;;
```
and with the following big-step semantics:
```ocaml
------------------ [E-True]
eval True = true

------------------ [E-False]
eval False = false

eval e0 = true
--------------------------- [E-IfTrue]
eval If(e0,e1,e2) = eval e1

eval e0 = false
--------------------------- [E-IfFalse]
eval If(e0,e1,e2) = eval e2
```

## Project setup

```bash
dune init proj boolexpr
```

At the end of the file dune-project, add the following line:
```bash
(using menhir 2.1)
```

```bash
dune build
```

```bash
dune utop src
```

## Lexer and parser

## Big-step semantics

```ocaml
let rec eval = function
    True -> true
  | False -> false
  | If(e0,e1,e2) -> if eval e0 then eval e1 else eval e2
;;
```
