module StringSet = Set.Make(String)

(* bind f x k is the function f' where x is mapped to k on top of f *)
let bind f x k = fun s -> if x = s then k else f s

(* fzip dmn cdm : a' list -> b' list -> (a' -> b') is the function that maps
   each element of dmn to one element of cdm in the order they appear *)
let rec fzip xs ys = match xs,ys with
  | [],[] -> fun _ -> failwith "Rock bottom"
  | [],_::_ | _::_,[] -> failwith "Cannot zip: lists do no match in size!"
  | x::xs',y::ys' -> bind (fzip xs' ys') x y

(* range a b is the integer interval [a;b) encoded as a list *)
let rec range a b = if a < b then a::(range (a+1) b) else []
