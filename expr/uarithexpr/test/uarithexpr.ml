open UarithexprLib.Main

(* wrapping results for testing *)

type wexprval = Ok of exprval | Error

let string_of_wval = function 
    Ok v -> string_of_val v
  | _ -> "Error"

let weval e = try Ok (eval e) 
  with _ -> Error
;;
  
let tests = [
  ("if true then true else false and false",Nat 1);
  ("if true then false else false or true",Nat 0);
  ("succ 0",Nat 1);
  ("succ succ succ pred pred succ succ pred succ pred succ 0", Nat 3);
  ("iszero pred succ 0", Nat 1);
  ("iszero pred succ 0 and not iszero succ pred succ 0", Nat 1);
  ("iszero true", Nat 0);
  ("succ iszero 0", Nat 2);
  ("not 0", Nat 1);
];;

let oktests = List.map (fun (x,y) -> (x,Ok y)) tests;;

let errtests = [
  ("pred 0", Error);
  ("pred pred succ 0", Error)
];;

let%test _ = List.fold_left
    (fun b (s,v) ->
       print_string (s ^ " => ");
       let b' = ((s |> parse |> weval) = v) in
       print_string (string_of_wval v);
       print_string (" " ^ (if b' then "[OK]" else "[NO]"));
       print_newline();
       b && b')
    true
    (oktests @ errtests)
;;
