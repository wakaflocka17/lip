# LiP Lab

## Ocaml crash course #1

You can work on these exercises using the online Ocaml playground: [Try Ocaml](https://try.ocamlpro.com/).

### Exercise #1: absolute value

Implement a function with the following type:
```ocaml
val f : int -> int = <fun>
```
such that f x is the absolute value of x.


### Exercise #2: from type to function

Implement any function with the following type:
```ocaml
val f : (int -> int) -> int = <fun>
```
The actual behaviour of f is not important for this exercise: just write a function with the required type.


### Exercise #3: find a function

Consider the following Ocaml snippet:
```ocaml
let rec f x y = 
  if x y = 0 then f x (y+1)
  else x y
;;
```
Find a g such that f g 0 = 3.

## Ocaml crash course #2

*TBA*

## References

- [OCaml Programming: Correct + Efficient + Beautiful](https://cs3110.github.io/textbook/cover.html)
