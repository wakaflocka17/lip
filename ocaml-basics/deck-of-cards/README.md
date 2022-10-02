# Deck of cards

Consider the following types to represent french cards:
```ocaml
type suit = Spades | Hearts | Diamonds | Clubs;;
type card = Card of int * suit;;
```
A card is valid iff the first element its value is comprised between 1 (Ace) and 10 (King).

A deck is a list of valid cards without duplicates, and it is
*complete* if it includes exactly 40 cards.

Write a function with type:
```ocaml
val is_complete : card list -> bool = <fun>
```
which evaluates to true iff the argument is a complete deck.

Then, recall the Ocaml function to generate random numbers bounded by a given integer:
```ocaml
# Random.int;;
- : int -> int = <fun>
```

Write a function with type:
```ocaml
val gen_deck : unit -> card list = <fun>
```
to generate a complete random deck of cards.

