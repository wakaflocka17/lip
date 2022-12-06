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

let parse (s : string) : named_term =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast

let gammafy vars =
  let rec helper acc = function 
  | [] -> []
  | _::t -> acc::(helper (acc-1) t)

  in helper ((List.length vars)-1) vars

let rec free_vars = function
  | NamedVar x -> [x]
  | NamedAbs(x,t) -> List.filter ((<>) x) (free_vars t)
  | NamedApp(t1,t2) -> (free_vars t1) @ (free_vars t2)

exception UnboundVar

let bind f x k = fun s -> if x = s then k else f s

let rec helper env dist = function
  | NamedVar x -> DBVar(
    (* Compute the k-th enclosing binder (from right to left) for the name x:
       How many enclosing binders have I met? - When was this name bound?
       The most recently bound names get the smaller values *)
    dist - env x
    )
  | NamedAbs(x,u) -> DBAbs(helper (bind env x (dist+1)) (dist+1) u)
  | NamedApp(u,v) -> DBApp(helper env dist u, helper env dist v)

let dbterm_of_namedterm t = 
  let bottom = fun _ -> raise UnboundVar     
  in helper bottom 0 t
