# Simply typed lambda-calculus

Write an interpreter of the simply typed lambda-calculus with bool and nat base types, according to the following guidelines.

## Abstract syntax

The abstract syntax of the language is defined in [ast.ml](lib/ast.ml)
as follows:
```ocaml
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
Note that, unlike in the [untyped lambda-calculus](../untyped), in the simply typed lambda-calculus the variables in abstractions are **explicitly typed**. The possible types are defined by the following abstract syntax:
```ocaml
type ty = TBool | TNat | TFun of ty * ty
```
where the type `TBool` represents booleans, the type is for `TNat` naturals, and `TFun` for function types.
For instance, the term:
```ocaml
fun f: nat->bool. f 0
```
represents a function that takes as argument a function f from nat to bool, and applies it to 0.
Its abstract syntax is:
```ocaml
"fun f: nat->bool. f 0" |> parse;;
- : term = Abs ("f", TFun (TNat, TBool), App (Var "f", Zero))
```

## Type checking

Write a function with type
```ocaml
typecheck : (string -> ty) -> term -> ty
```
such that `typecheck gamma t` returns the type of the term `t` in the type environment `gamma`, or raises a `TypeError` exception if the term is not typeable.

For instance, we expect to have:
```ocaml
(fun x:nat. iszero x) 0" |> parse |> typecheck bot;;
- : ty = TBool

fun x:nat. iszero x" |> parse |> typecheck bot;;
- : ty = TFun (TNat, TBool)
```
