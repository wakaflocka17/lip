# Pure untyped lambda calculus

Write an interpreter of the pure untyped lambda-calculus,
according to the following guidelines.

## Abstract syntax

The terms of the language are variables, lambda-abstractions and
applications between two terms.
The abstract syntax of the language is defined in [ast.ml](bin/ast.ml)
as follows:
```ocaml
type term =
    Var of string
  | Abs of string * term
  | App of term * term
```

## Pretty printer

```ocaml
string_of_term : term -> string
```

## Concrete syntax

The [lexer](lib/lexer.mll) and the [parser](parser.mly)
are already provided in the repository.
The parser ensures that function application associates to the left.
For instance, in utop:
```ocaml
open UntypedLib.Main;;
open UntypedLib.Ast;;

"f g h" |> parse;;
- : term = App (App (Var "f", Var "g"), Var "h")

term =
App (App (Abs ("x", Var "x"), Abs ("y", App (Var "y", Var "z"))),
 Abs ("z", App (App (Var "x", Var "y"), Var "z")))
```

## Free variables

```ocaml
is_free : string -> term -> bool
```

## Alpha-equivalence

```ocaml
equiv : term -> term -> bool
```

## Substitutions

```ocaml
subst : string -> term -> int -> term -> term * int
```

## Small-step semantics

```ocaml
trace : int -> term -> term
```