open Ast
open Help

exception UnboundVar


let parse (s : string) : namedterm =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast


let rec free_vars = function
  | NamedVar x -> [x]
  | NamedAbs(x,t) -> List.filter ((<>) x) (free_vars t)
  | NamedApp(t1,t2) -> (free_vars t1) @! (free_vars t2)


(* removenames1 c t is the nameless representation of a named term t using an 
   arbitrary mapping c of its free variables to De Bruijn indexes. Yields the 
   corresponding n-term, where n is the number of free variables present in t, 
   namely the size of dom(c) *)
let removenames1 gamma t =
  let rec walk env depth = function
    | NamedVar x -> DBVar (
      try
      (* x was previously bound: its index equals the depth level of its binder 
         as recorded in the environment minus the number of enclosing lambda-
         abstractions crossed so far. *)
        depth - env x

      with
      (* x occurs free: shift its index obtained by the context to reflect
         the current one where d enclosing abstractions have been crossed. *)
        UnboundVar -> gamma x + depth
    )

    (* Each abstraction is one level of depth lower than its body. The bound
       name is mapped to the current depth (starting from 1) *)
    | NamedAbs(x,u) -> DBAbs(walk (bind env x (depth+1)) (depth+1) u)
    
    | NamedApp(u,v) -> DBApp(walk env depth u, walk env depth v) 
  
    
  in walk (fun _ -> raise UnboundVar) 0 t


(* removenames t is the nameless representation of a named term t using a 
   default context where each free variable is mapped to a serial index *)
let removenames t =
  let fv = free_vars t in

  (* Establish a naming context for the free variables of t by assigning an
     increasing index to each one of them, right to left, starting from 0 *)
  let context = fzip fv (range 0 (List.length fv))

  in removenames1 context t 


(* shift d c t is the d-place shift of a term t above cutoff c *)
let shift d t =
  let rec walk c = function
  | DBVar k -> DBVar (if k < c then k else k+d)
  | DBAbs t1 -> DBAbs (walk (c+1) t1)
  | DBApp(t1,t2) -> DBApp(walk c t1, walk c t2)

  in walk 0 t


(* subst j s t is the De Bruijn term [j -> s] t *)
let subst j s t =
  let rec walk c = function
  | DBVar k -> if k = j+c then s else DBVar k
  | DBAbs t1 -> DBAbs (walk (c+1) t1)
  | DBApp(t1,t2) -> DBApp(walk c t1, walk c t2)

  in walk 0 t
