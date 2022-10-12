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

To start, launch the following command from your working directory:
```bash
dune init proj boolexpr
```
The command creates the following file structure:
```
boolexpr/
├── dune-project
├── bin
│   └── dune
│   └── main.ml
├── lib
│   └── dune
├── test
│   ├── dune
│   └── boolexpr.ml
└── boolexpr.opam
```

To check that the OCaml installation was successful, try to execute the project:
```bash
dune exec boolexpr
```
If everything is fine, the output will be:
```
Hello, World! 
```
To instruct dune that our project will use Menhir, add the following line at the end of the file `dune-project`:
```bash
(using menhir 2.1)
```
Now, create a directory `src` under `boolexpr`:
```bash
mkdir src
```
The `src` directory will have the following structure:
```
src/
├── ast.ml         # Abstract syntax tree
├── dune           # Dune library definition
├── lexer.mll      # Ocamllex lexer
├── main.ml        # Language semantics and utility functions
├── parser.mly     # Menhir parser
```
We will discuss these files in the following sections.

## Lexer and parser

```ocaml
%{
open Ast
%}

%token TRUE
%token FALSE
%token LPAREN
%token RPAREN
%token IF
%token THEN
%token ELSE
%token EOF

%start <Ast.boolExpr> prog

%%

prog:
  | e = expr; EOF { e }
;

expr:
  | TRUE { True }
  | FALSE { False }
  | IF; e1 = expr; THEN; e2 = expr; ELSE; e3 = expr; { If(e1, e2, e3) }
  | LPAREN; e=expr; RPAREN {e}
;
```

## Testing the parser

```bash
dune utop src
```


## Big-step semantics

```ocaml
let rec eval = function
    True -> true
  | False -> false
  | If(e0,e1,e2) -> if eval e0 then eval e1 else eval e2
;;
```
