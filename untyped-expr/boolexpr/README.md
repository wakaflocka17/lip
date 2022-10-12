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

## Project initialization

## Lexer and parser

## Big-step semantics
