# Pure untyped lambda calculus

Write an interpreter of the pure untyped lambda-calculus,
according to the following guidelines.

The repository already contains the frontend, the parser and the inline tests, as well as some utility functions.
Before starting, synchronize and pull the repository, and rename the file [lib/main.ml_skeleton](lib/main.ml_skeleton)
into lib/main.ml (use the command `git mv lib/main.ml_skeleton lib/main.ml` from your local copy of the repository).

## Abstract syntax

The terms of the language are variables, lambda-abstractions and
applications between two terms.
The abstract syntax of the language is defined in [ast.ml](lib/ast.ml)
as follows:
```ocaml
type term =
    Var of string
  | Abs of string * term
  | App of term * term
```

## Pretty printer

The repository already contains a pretty printer for the terms of the language, with type:
```ocaml
string_of_term : term -> string
```
You can test it via `dune utop lib` as follows:
```ocaml
open UntypedLib.Main;;
open UntypedLib.Ast;;
Abs("z", App(App (Var "x", Var "y"), Var "z")) |> string_of_term;;
- : string = "fun z. (x y) z"
```

## Concrete syntax

The [lexer](lib/lexer.mll) and the [parser](parser.mly)
are already provided in the repository.
The parser ensures that function application associates to the left.
For instance, in utop:
```ocaml
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
