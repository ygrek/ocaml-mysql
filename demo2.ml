(**
  Demo for the Mysql.Prepared module
*)

open Printf
module P = Mysql.Prepared

(* 
  Verify safe GC interaction (see CAML_TEST_GC_SAFE in mysql_stubs.c)
  For such test need strings on heap, not statically allocated atoms, hence String.copy
*)
let _ = Thread.create (fun () -> 
  let i = ref 0 in 
  while true do Gc.compact(); incr i; if !i mod 100 = 0 then (print_char '.'; flush stdout) done) ()

let s = String.copy

let db = Mysql.quick_connect ~database:(s "test") ~user:(s "root") ()

let _ = Mysql.exec db (s "CREATE TABLE IF NOT EXISTS test(id INT) ENGINE=MEMORY")
let () =
  let insert = P.create db (s "INSERT INTO test VALUES (?)") in
  for i = 10 to 20 do
    ignore (P.execute insert [|string_of_int i|])
  done;
  P.close insert

let () =
  let rec loop t =
    match P.fetch t with
    | Some arr -> Array.iter (function Some s -> printf "%s " s | None -> print_string "<NULL> ") arr; print_endline ""; loop t
    | None -> ()
  in
  let select = P.create db (s "SELECT * FROM test WHERE id > ?") in
  print_endline "> 15";
  loop (P.execute select [|s "15"|]);
  print_endline "> 20";
  loop (P.execute select [|s "20"|]);
  print_endline "> 19";
  loop (P.execute select [|s "19"|]);
  P.close select;
  print_endline "done all";
  ()

let _ = Mysql.exec db (s "DROP TABLE test")

let () = Mysql.disconnect db

