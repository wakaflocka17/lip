# Simply typed lambda calculus


## Abstract syntax

The abstract syntax of the language is defined in [ast.ml](lib/ast.ml)
as follows:
```ocaml
type ty = TBool | TNat | TFun of ty * ty

type term =
    Var of string
  | Abs of string * ty * term
  | App of term * term
  | True
  | False
  | Not of term
  | And of term * term
  | Or of term * term
  | If of term * term * term
  | Zero
  | Succ of term
  | Pred of term
  | IsZero of term
```
Note that the variables in lambda-abstractions are explicitly typed, where types are
booleans, naturals, and function types.
For instance, the term:
```ocaml
Abs("f", TFun(TNat,TBool), App(Var "f",Zero))
```
represents a function that takes as argument a function f from nat to bool, and applies it to 0.
