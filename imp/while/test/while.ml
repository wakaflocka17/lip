open WhileLib.Ast
open WhileLib.Main

(**********************************************************************
 parse test : (variable, term, expected result)
 **********************************************************************)

let test_parse = [
  ("x := 0", Assign("x",Const(0)));
]

let%test _ =
  print_newline ();
  print_endline ("*** Testing parse...");
  List.fold_left
    (fun b (ts,t) ->
       print_string ts;
       let b' = (parse ts = t) in
       print_string (" " ^ (if b' then "[OK]" else "[NO : expected " ^ string_of_cmd t ^ "]"));
       print_newline();
       b && b')
    true
    test_parse


(**********************************************************************
 trace test : (command, n_steps, variable, expected value after n_steps)
 **********************************************************************)

let test_trace = [
  ("x:=0", 1, "x", Nat 0);
  ("x:=0; x:=x+1", 2, "x", Nat 1);
  ("x:=0; y:=x+1; x:=y+1", 3, "x", Nat 2);
  ("x:=0; if x=0 then y:=1 else y:=2", 3, "y", Nat 1);
  ("x:=1; if x=0 then y:=1 else y:=2", 3, "y", Nat 2);
  ("x:=3; y:=2; r:=0; while 1<=y do (r:=r+x; y:=y-1)", 10, "r", Nat 6);
]
              
let%test _ =
  print_newline();
  print_endline ("*** Testing trace...");  
  List.fold_left
    (fun b (cs,n,x,v) ->
       let c = parse cs in
       let t = last (trace n c) in (* actual result *)
       print_string (cs ^ " ->* " ^ string_of_conf (vars_of_cmd c) t);
       let b' = (match t with
             St s -> s x = v
           | Cmd(_,s) -> s x = v) in
       print_string (" " ^ (if b' then "[OK]" else "[NO : expected " ^ string_of_val v ^ "]"));
       print_newline();
       b && b')
    true
    test_trace
