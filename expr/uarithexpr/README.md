# Untyped arithmetic expressions

Define an alternative semantics of arithmetic expressions where runtime errors are never generated.
To do so, mimick the behaviour of C and C++, which encode False as 0 and True as any value different from 0.

For instance, we expect the big-step semantics to produce the evaluations:
```
iszero true => 0

succ iszero 0 => 2

not 0 => 1

succ 0 and succ succ 0 => 1

succ 0 or 0 => 1
```

To ensure that `pred e` never fails, assume that the predecessor of 0 is 0.
Therefore, your semantics must satisfy the following:
```
pred 0 => 0

pred pred 0 => 0
```
