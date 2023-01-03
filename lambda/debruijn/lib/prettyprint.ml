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
