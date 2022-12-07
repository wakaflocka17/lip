open Ast

let rec string_of_namedterm = function
    NamedVar x -> x
  | NamedAbs(x,t) -> "fun " ^ x ^ ". " ^ string_of_namedterm t
  | NamedApp(NamedVar x,NamedVar y) -> x ^ " " ^ y
  | NamedApp(NamedVar x,t2) -> x ^ " (" ^ string_of_namedterm t2 ^ ")"
  | NamedApp(t1,NamedVar x) -> "(" ^ string_of_namedterm t1 ^ ") " ^ x
  | NamedApp(t1,t2) -> "(" ^ string_of_namedterm t1 ^ ") (" ^ string_of_namedterm t2 ^ ")"

let rec string_of_dbterm = function
    DBVar n -> string_of_int n
  | DBAbs t -> "fun . " ^ string_of_dbterm t
  | DBApp(DBVar n,DBVar m) -> string_of_int n ^ " " ^ string_of_int m
  | DBApp(DBVar n,t2) -> string_of_int n ^ " (" ^ string_of_dbterm t2 ^ ")"
  | DBApp(t1,DBVar n) -> "(" ^ string_of_dbterm t1 ^ ") " ^ string_of_int n
  | DBApp(t1,t2) -> "(" ^ string_of_dbterm t1 ^ ") (" ^ string_of_dbterm t2 ^ ")"

let parse (s : string) : namedterm =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast

let rec free_vars t =
  let (@!) l1 l2 = List.fold_right 
    (fun x acc -> if List.exists ((=) x) l1 then acc else x::acc) l2 l1

  in match t with
  | NamedVar x -> [x]
  | NamedAbs(x,t) -> List.filter ((<>) x) (free_vars t)
  | NamedApp(t1,t2) -> (free_vars t1) @! (free_vars t2)

exception UnboundVar

let bind f x k = fun s -> if x = s then k else f s

(* Nameless representation of a named term t using an arbitrary mapping c of its
   free variables to De Bruijn indexes. Yields the corresponding n-term, where 
   n is the number of free variables present in t, namely the size of dom(c) *)
let dbterm_of_namedterm c t =

  (* Helper function that carries:
     An environment env to keep track of the absolute position of each binder 
     hhe distance d from the outer-most enclosing binder *)
  let rec helper env d = function

    | NamedVar x -> DBVar(try
      (* The k-th enclosing binder (from right to left) for the name x equates 
         to: How many enclosing binders have I met? - When was this name bound?
         The most recently bound names get the smaller values *)
        d - env x

      (* If the name is not bound by an abstraction then it must be free;
       get its value from the context and shift it outside the bound region *)
      with
        UnboundVar -> c x + d
    )

    (* Each abstraction is one level of depth lower than its body. The bound
       name is mapped to the current depth (starting from 1) *)
    | NamedAbs(x,u) -> DBAbs(helper (bind env x (d+1)) (d+1) u)
    | NamedApp(u,v) -> DBApp(helper env d u, helper env d v) 
  
  in helper (fun _ -> raise UnboundVar) 0 t

(* Nameless representation of a named term t using a default context *)
let dbterm_of_namedterm_auto t =
  let fv = free_vars t in

  (* Functional zip of two lists of equal size.
     a' list -> b' list -> (a' -> b') *)
  let rec fzip xs ys = match xs,ys with
    | [],[] -> fun _ -> failwith "Undefined"
    | [],_::_ | _::_,[] -> failwith "Cannot zip: lists do no match in size!"
    | x::xs',y::ys' -> bind (fzip xs' ys') x y
  in

  (* Establish a naming context for the free variables of t by assigning an
     increasing index to each one of them, right to left, starting from 0 *)
  let context = fzip fv (List.rev (List.init (List.length fv) (fun x -> x)))

  in dbterm_of_namedterm context t 
