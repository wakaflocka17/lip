open StaticLib.Types       
open StaticLib.Prettyprint
open StaticLib.Main


(**********************************************************************
 trace test : (command, n_steps, location, expected value after n_steps)
 **********************************************************************)

let test_trace = [
  ("int x; x:=51;", 2, "x", 51);
  ("int x; x:=0; x:=x+1;", 5, "x", 1);
  ("int x; int y; x:=0; y:=x+1; x:=y+1;", 10, "x", 2);
  ("int x; int y; x:=0; if x=0 then y:=10; else y:=20;", 5, "y", 10);
  ("int x; int y; x:=1; if x=0 then y:=10; else y:=20;", 5, "y", 20);
  ("int x; int y; int r; x:=3; y:=2; r:=0; while 1<=y do ( r:=r+x; y:=y-1; )", 30, "r", 6);
  ("int x; int y; x:=3; while 0<=x and not 0=x do x:=x-1; x:=5;", 50, "x", 5);
  ("int min; int x; int y; x:=5; y:=3; if x<=y then min:=x; else min:=y;", 40, "min", 3);
  ("int min; int x; int y; int z; x:=1; y:=2; z:=3; if x<=y and x<=z then min:=x; else ( if y<=z then min:=y; else min:=z; )", 40, "min", 1);
  ("int x; fun f(y) { return y+1 } x := f(10);", 20, "x", 11);
  ("int x; fun f(y) { return y+1 } fun g(z) { return f(z)+2 } x := g(10);", 20, "x", 13);
  ("int x; int z; fun f(y) { x:=x+1; return x } x := 10; z := f(0);", 20, "x", 11);
  ("int x; int z; fun f(y) { x:=x+1; return x } x := 10; z := f(0);", 20, "z", 11);
  ("int x; int y; int w; fun f(z) { z:=x; x:=y; y:=z; return 0 } x := 10; y := 20; w := f(0);", 20, "x", 20);
  ("int x; int y; int w; fun f(z) { z:=x; x:=y; y:=z; return 0 } x := 10; y := 20; w := f(0);", 20, "y", 10);
  ("int x; int y; fun f(x) { x:=20; return 0 } x := 10; y := f(0); x := x+1;", 20, "x", 11);
  (* new tests *)
  ("int y; y:=0; { int x; fun swap(n) { n := x; x := y; y := n; return 0 } x:=42; { int x; x:=1; swap(0); } }", 20, "y", 42);
  ("int r; int n; fun f(x) { return n+x } fun g(n) { return f(n) } n:=1; r:=g(10);", 20, "r", 11);
  ("int x; int r; fun f(n) { if n=0 then r:=1; else r:=n*f(n-1); return r } x := f(5);", 100, "x", 120);
]

              
let%test _ =
  print_newline();
  print_endline ("*** Testing trace...");  
  List.fold_left
    (fun b (ps,n,x,v) ->
       let p = parse ps in
       let t = last (trace n p) in (* actual result *)
       print_string (ps ^ " ->* " ^ string_of_conf (vars_of_prog p) t);
       let b' = (match t with
             St st -> apply st x = v
           | Cmd(_,_) -> failwith "program not terminated") in
       print_string (" " ^ (if b' then "[OK]" else "[NO : expected " ^ string_of_val v ^ "]"));
       print_newline();
       b && b')
    true
    test_trace
