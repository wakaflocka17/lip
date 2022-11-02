# Church numerals

Extend the [pure untyped lambda calculus](../untyped) with the following combinators:
- Church booleans:
  - tru = fun t. fun f. t
  - fls = fun t. fun t. f
  - ift = fun l. fun m. fun n. l m n

## Lexer and parser

## Pretty-printing

## Small-step semantics
