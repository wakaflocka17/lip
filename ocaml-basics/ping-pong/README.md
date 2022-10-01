# Ping pong

A list of integers is *alternating* if for each sublist [a;b;c] of three elements, the ordering relation between a and b is the inverse of the one between b and c.
For instance consider the following lists:
```ocaml
let l0 = [1;5;2;5;1;6];;
let l1 = [1;5;2;5;4;3];;
let l2 = [1;5;2;3;2;4];;
let l3 = [1;3;2;4;3;5];;
```
Here, `l0`, `l2` and `l3` are alternating, while `l1` is not.

A list of integer is *ping pong* if there is some central element
(the "net") around which the others alternate.
For instance, the list `l0` above is ping pong, while the others are not.
In particular,
`l1` is not altrnating;
in `l2`, the net should be between 2 and 3,
but there are no integers within that interval;
in `l3`, the net is shifting towards the right: it is 2 at the first step,
3 at the second step, and 4 at the third.
