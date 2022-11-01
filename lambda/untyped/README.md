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

The repository already contains a pretty printer for the terms of the language:
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
Hereafter, when we use utop we assume that the first two `open` commands are always given.


## Concrete syntax

The [lexer](lib/lexer.mll) and the [parser](parser.mly)
are already included in the repository.
The parser ensures that function application associates to the left.
For instance, in utop:
```ocaml
"f g h" |> parse;;
- : term = App (App (Var "f", Var "g"), Var "h")

(fun x. x) (fun y. y z) (fun z. x y z)" |> parse |> string_of_term;;
- : string = "((fun x. x) (fun y. y z)) (fun z. (x y) z)"
```

## Free variables

Write a function to detect if a variable is free in a term, with type:
```ocaml
is_free : string -> term -> bool
```

The free variables of a term t, written fv(t), are defined inductively as follows:
```
fv(x) = {x}

fv(fun x . t) = fv(t) \ {x}

fv(t1 t2) = fv(t1) U fv(t2)
```

For instance, we have that:
```ocaml
"fun x . x (fun y . (x y) z)" |> parse |> (is_free "x");;
- : bool = false

"fun x . x (fun y . (x y) z)" |> parse |> (is_free "y");;
- : bool = false

"fun x . x (fun y . (x y) z)" |> parse |> (is_free "z");;
- : bool = true
```

## Alpha-equivalence

To terms are alpha-equivalent when they have exactly the same structure, except for the choice of bound names.
Write a funtion with type:
```ocaml
equiv : term -> term -> bool
```
which detects if two terms are alpha-equivalent. For instance, we must have:
```ocaml
equiv ("fun x . x y" |> parse) ("fun z . z y" |> parse);;
- : bool = true

equiv ("fun x . x y" |> parse) ("fun z . z z" |> parse);;
- : bool = false

equiv ("fun x . (fun y . x)" |> parse) ("fun y . (fun x . y)" |> parse);;
- : bool = true
```

## Substitutions

Write a function to substitute a term t for all the free occurrences of a variable x within a term t'.
Such substitution is denoted as `[x -> t] t'`.
For instance, we expect that:
```
[x -> (fun z . z w)] (fun y . x) = fun y . fun z . z w
```
Note bound occurrences of x must *not* be substituted. For instance is would be *wrong* to obtain:
```
[x -> y] (fun x . x) = fun x . y
```
Since the term `fun x . x` is alpha-equivalent to `fun z . z`, from which we would obtain:
```
[x -> y] (fun z . z) = fun z . z
```
Another delicate issue is that of **variable capture**, as in the following substitution:
```
[x -> z] (fun z . x)
```
Here, it would be *wrong* to obtain:
```
[x -> z] (fun z . x) = fun z . z
```
Indeed, since `fun z . x` is alpha-equivalent to `fun w . x`, we would also obtain:
```
[x -> z] (fun z . x) = fun w . z
```
but the two resulting terms `fun z . z` and `fun w . z` are *not* alpha-equivalent.

To guarantee that substitutions are capture-avoiding, we implement an **explicit renaming of bound variables**.
To this purpose, substitutions take an extra argument i, which stands for the index of a fresh variable that we can use for such renamings.
For instance, assuming this index is 1, we have:
```
[x -> y z] 1 (fun y . x (fun w . x) = fun x1 . (y z) (fun w . y z)

[x -> y z] 3 (fun y . x (fun z . x y z) = fun x3 . (y z) (fun x4 . ((y z) x3) x4)
```

Using this technique, implement a substitution function with the following type:
```ocaml
subst : string -> term -> int -> term -> term * int
```
For instance, we expect that:
```ocaml
subst "x" ("y z" |> parse) 3 ("fun y . x  (fun z . x y z)" |> parse) |> fst |> string_of_term;;
- : string = "fun x3. (y z) (fun x4. ((y z) x3) x4)"
```

## Small-step semantics

Implement the small-step semantics of the language, using the *call-by-value* evaluation strategy:
```
v ::= fun x . t

t1 -> t1'
------------------------------- [E-App1]
t1 t2 -> t1' t2

t2 -> t2'
------------------------------- [E-App2]
v1 t2 -> v1 t2'

------------------------------- [E-AppAbs]
(fun x . t1) v2 -> [x -> v2] t1
```

The evaluation function must have the following type:
```ocaml
trace : int -> term -> term
```
where the integer argument stands for the number of steps to be performed.


## Frontend and testing

Run the frontend with the command:
```
dune exec untyped n
```
where n is the number of evaluation steps. For instance, with n=4 we should obtain:
```
((fun x. (x x) x) (fun y. y)) (fun z. z)
 -> (((fun y. y) (fun y. y)) (fun y. y)) (fun z. z)
 -> ((fun y. y) (fun y. y)) (fun z. z)
 -> (fun y. y) (fun z. z)
 -> fun z. z
```
