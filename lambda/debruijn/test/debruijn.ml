open DebruijnLib.Ast
open DebruijnLib.Main
open DebruijnLib.Prettyprint

let c0 = "fun s. fun z. z"
let c1 = "fun s. fun z. s z"
let c2 = "fun s. fun z. s (s z)"
let plus = "fun m. fun n. fun s. fun z. m s (n s z)"

let test_removenames = [
  ("fun x. x", DBAbs (DBVar 0));
  ("fun z. z", DBAbs (DBVar 0));
  (c0, DBAbs (DBAbs (DBVar 0)));
  (c1, DBAbs (DBAbs (DBApp (DBVar 1, DBVar 0))));
  (c2, DBAbs (DBAbs (DBApp (DBVar 1, DBApp (DBVar 1, DBVar 0)))));
  (plus, DBAbs
    (DBAbs
      (DBAbs
        (DBAbs
          (DBApp (DBApp (DBVar 3, DBVar 1),
            DBApp (DBApp (DBVar 2, DBVar 1), DBVar 0)))))));
  ("(fun x. fun x. x) (fun y. y)", DBApp (DBAbs (DBAbs (DBVar 0)), DBAbs (DBVar 0)));
  ("x", DBVar 0);
  ("a b", DBApp (DBVar 0, DBVar 1));
  ("b a", DBApp (DBVar 1, DBVar 0));
  ("fun z. x y z", DBAbs (DBApp (DBApp (DBVar 1, DBVar 2), DBVar 0)));
  ("fun y . y x (fun z . y z x w) w z y", DBAbs
    (DBApp
      (DBApp
        (DBApp
          (DBApp (DBApp (DBVar 0, DBVar 2),
            DBAbs (DBApp (DBApp (DBApp (DBVar 1, DBVar 0), DBVar 3), DBVar 2))),
          DBVar 1),
        DBVar 3),
      DBVar 0)))
]


let%test _ =
  print_newline ();
  print_endline ("*** Testing removenames...");
  List.fold_left
    (fun b (ts,t) ->
       print_string ts;
       let b' = (removenames (parse ts) = t) in
       print_string (" " ^ (if b' then "[OK]" else "[NO : expected " ^ string_of_dbterm t ^ "]"));
       print_newline();
       b && b')
    true
    test_removenames
