open Ast

let rec string_of_term = function
    Var x -> x
  | Abs(x,t) -> "fun " ^ x ^ ". " ^ string_of_term t
  | App(Var x,Var y) -> x ^ " " ^ y
  | App(Var x,t2) -> x ^ " (" ^ string_of_term t2 ^ ")"
  | App(t1,Var x) -> "(" ^ string_of_term t1 ^ ") " ^ x
  | App(t1,t2) -> "(" ^ string_of_term t1 ^ ") (" ^ string_of_term t2 ^ ")"

let parse (s : string) : term =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast


(**********************************************************************
 size : term -> int
 **********************************************************************)

let rec size = failwith "TODO"


(**********************************************************************
 is_free : string -> term -> bool

 Usage: is_free x t = true iff the variable x occurs free in t
 **********************************************************************)
let rec is_free x = failwith "TODO"


(**********************************************************************
 rename : string -> string -> term -> term

 Usage: rename x x' t replaces all free occurrences of x in t as x'

 Pre: x' does not occur free in t
 **********************************************************************)

let rec rename x x' = failwith "TODO"


(**********************************************************************
 equiv : term -> term -> bool

 Usage: equiv t1 t2 = true iff t1 and t2 are alpha-equivalent
 **********************************************************************)
               
let equiv t1 t2 = failwith "TODO"
                   

(**********************************************************************
 subst : string -> term -> int -> term -> term * int

 Usage: subst x t1 vars t2 = ([x -> t1] t2,vars')  
        where vars is the index of the next variable to be used for renaming
        and vars' is the next available index after the substitution
 **********************************************************************)

let rec subst x t vars = failwith "TODO"

(**********************************************************************
 is_val : term -> bool

 Usage: is_val t = true iff t is a value (i.e., a lambda-abstraction)
 **********************************************************************)

let is_val = failwith "TODO"


exception NoRuleApplies

(**********************************************************************
 trace1 : int -> term -> term * int

 Usage: trace1 vars t performs a step of the small-step call-by-value semantics

 Pre:  xk does not occur in t, for all k>=vars
 **********************************************************************)

let rec trace1 = failwith "TODO"


(**********************************************************************
 trace_rec : int -> term -> term * int

 Usage: trace_rec n vars t performs n steps of the small-step semantics

 Pre:  xk does not occur in t, for all k>=vars
 **********************************************************************)

let trace = failwith "TODO"
