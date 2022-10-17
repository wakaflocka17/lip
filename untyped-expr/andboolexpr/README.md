# Boolean expressions with not, and, or

Extend the language of [simple boolean expressions](../boolexpr) with the logical connectives, according to the following [AST](src/ast.ml):
```ocaml
type boolExpr =
    True
  | False
  | Not of boolExpr
  | And of boolExpr * boolExpr
  | Or of boolExpr * boolExpr
  | If of boolExpr * boolExpr * boolExpr
```

The meaning of the new constructors is the following:
- **Not e**, the logical negation of e;
- **And(e1,e2)**, the conjunction between e1 and e2;
- **Or(e1,e2)**, the disjunction between e1 and e2.

Follow the unit tests in [andboolexpr.ml](test/andboolexpr.ml) for the concrete syntax of the language. 
To run the tests, execute the following command from the project directory:
```
dune test
```

You should take care of assigning the right [priority and associativity](http://gallium.inria.fr/~fpottier/menhir/manual.html#sec12) 
to the new connectives, to make their semantics coherent with that of the corresponding OCaml operators. 

In particular, `not` has higher priority than `and`, which in turn has higher priority than `or`.
For instance:
- `not true or true` must evaluate to `true`;
- `not true and false` must evaluate to `false`;
- `false and false or true` must evaluate to `true`;
- `true or false and false` must evaluate to `true`.

Furthermore, we want the if-then-else construct have lower priority over the other connectives. For instance:
- `if true then true else false and false` must evaluate to `true`;
- `if true then false else false or true`  must evaluate to `false`.

The extension will touch the following files and functions:
- **parser.mly**: add new tokens, productions, and token priorities;
- **lexer.mll**: add lexing rules for new tokens;
- **src/main.ml**: extend the functions `string_of_boolexpr`, `trace1` and `eval` for the new variants.
