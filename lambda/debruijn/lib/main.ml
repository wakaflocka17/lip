open Ast
open Help


let parse1 (s : string) : namedterm =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast


let rec free_vars = function
  | NamedVar x -> StringSet.singleton x
  | NamedAbs(x,t) -> StringSet.remove x (free_vars t)
  | NamedApp(t1,t2) -> StringSet.union (free_vars t1) (free_vars t2)


let shiftContext d c ctx = StringMap.map
  (fun v -> if v < c then v else v+d) ctx


(* removenames1 ctx t is the nameless representation of a named term t using
   de Bruin indexes: the index k represent the variable bound by the k-th
   enclosing binder. ctx is a context in which free variables are assigned
   arbitrary indexes. *)
let removenames1 gamma t =
  let rec walk c = function
    | NamedVar x -> DBVar (StringMap.find x c)
    | NamedAbs(x,u) -> DBAbs(walk (StringMap.add x 0 (shiftContext 1 0 c)) u)
    | NamedApp(u,v) -> DBApp(walk c u, walk c v) 
  
  in walk gamma t


(* removenames2 ctx t is the nameless representation of a named term t using 
   de Bruijn levels: bound variables are numbered from the outside in. *)
let removenames2 gamma t =
  let rec walk c depth = function
    | NamedVar x -> DBVar (StringMap.find x c)

    (* Each abstraction is one level of depth lower than its body. The bound
       name is mapped to the current depth (starting from 0) *)
    | NamedAbs(x,u) -> DBAbs(walk 
      (StringMap.add x depth (shiftContext 1 depth c)) (depth+1) u)
    
    | NamedApp(u,v) -> DBApp(walk c depth u, walk c depth v) 
  
  in walk gamma 0 t


(* removenames t is the nameless representation of a named term t using a 
   default context where each free variable is mapped to a serial index *)
let removenames t =
  let fv = free_vars t in

  (* Establish a naming context for the free variables of t by assigning an
     increasing index to each one of them, right to left, starting from 0 *)
  let context = mzip (StringSet.elements fv) (range 0 (StringSet.cardinal fv))

  in removenames1 context t


let parse (s : string) : dbterm = removenames (parse1 s)


(* shift d c t is the d-place shift of a term t above cutoff c *)
let shift d t =
  let rec walk c = function
  | DBVar k -> DBVar (if k < c then k else k+d)
  | DBAbs t1 -> DBAbs (walk (c+1) t1)
  | DBApp(t1,t2) -> DBApp(walk c t1, walk c t2)

  in walk 0 t


(* subst j s t is the substitution of [j -> s] t

   Substitution usually takes place inside of abstractions, thus the correct way
   to substitute s = 0 1 for the variable bound by the outermost λ in t = λ.λ.1 
   would be [0 -> 0 1] (λ.1) rather than [0 -> 0 1] (λ.λ.1), as the latter
   doesn't take into account the fact that j already points to a binder 
   (the leftmost λ in t) outside its body (λ.1).
*)
let subst j s t =
  let rec walk c = function
  (* s is shifted by the number of abstractions crossed to reflect the context
     in which it is substituted, that of the term t *)
  | DBVar k -> if k = j+c then shift c s else DBVar k
  | DBAbs t1 -> DBAbs (walk (c+1) t1)
  | DBApp(t1,t2) -> DBApp(walk c t1, walk c t2)

  in walk 0 t


let isval = function DBAbs _ -> true | _ -> false

let substTop s t = shift (-1) (subst 0 (shift 1 s) t)

exception NoRuleApplies

let rec trace1 = function
  | DBAbs t -> DBAbs (trace1 t) (* reduce redexes inside abstractions *)
  | DBApp(DBAbs t12,v2) -> substTop v2 t12
  | DBApp(v1,t2) when isval v1 -> DBApp(v1,trace1 t2)
  | DBApp(DBVar k,t2) -> DBApp(DBVar k,trace1 t2)
  | DBApp(t1,t2) -> DBApp(trace1 t1,t2)
  | _ -> raise NoRuleApplies

let rec trace n t =
  if n<=0 then [t]
  else try
      let t' = trace1 t
      in t::(trace (n-1) t')
    with NoRuleApplies -> [t]
