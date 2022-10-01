# Binary search trees

Consider the following type to represent (labelled) binary trees:
```ocaml
# type 'a btree = Empty | Node of 'a * 'a btree * 'a btree
```

A binary tree is a *binary search tree* if the label of each internal node
is greater than the labels of its left subtree, all less than those
of its right subtree.

For instance:
```ocaml
Node(7,
  Node(4,
    Node(1,Empty,Empty),
    Node(5,Empty,Empty))
  Node(10,Empty,Empty))
```
is a binary search tree.

Write a function with the following type:
```ocaml
val is_bstree : 'a btree -> ('a -> int) -> bool = <fun>
```
such that `is_bstree t comp` detects if t is a binary search tree
with respect to the comparison function `comp`.
Recall that, in Ocaml, a comparison between two elements
must return 0 if the elements are equal, a positive integer
if the first is greater, and a negative integer if the first is smaller.

Then, write a function:
```
val search : 'a btree -> ('a -> int) -> 'a -> bool = <fun>
```
such that `search t comp x` evaluates to true iff the element x belongs
to the binary search tree.
