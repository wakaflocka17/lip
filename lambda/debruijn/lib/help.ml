(* l1 @! l2 is the concatenation of lists l1 and l2 where each item of l2 is 
   considered once *)
let (@!) l1 l2 = List.fold_right 
  (fun x acc -> if List.exists ((=) x) l1 then acc else x::acc) 
  l2
  l1

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
