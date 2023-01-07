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


let removenames1 gamma t =
  let rec walk ctx = function
    | NamedVar x -> DBVar (StringMap.find x ctx)
    | NamedAbs(x,u) -> DBAbs(walk (StringMap.add x 0 (shiftContext 1 0 ctx)) u)
    | NamedApp(u,v) -> DBApp(walk ctx u, walk ctx v) 
  
  in walk gamma t


let removenames t =
  let fv = free_vars t in

  let context = mzip (StringSet.elements fv) (range 0 (StringSet.cardinal fv))

  in removenames1 context t


let parse (s : string) : dbterm = removenames (parse1 s)


let shift d t =
  let rec walk c = function
  | DBVar k -> DBVar (if k < c then k else k+d)
  | DBAbs t1 -> DBAbs (walk (c+1) t1)
  | DBApp(t1,t2) -> DBApp(walk c t1, walk c t2)

  in walk 0 t


let subst j s t =
  let rec walk c = function
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
