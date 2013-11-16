(**
  Demo for the Mysql.Prepared module
*)

open Printf
module P = Mysql.Prepared

(* 
  Verify safe GC interaction (see CAML_TEST_GC_SAFE in mysql_stubs.c)
  For such test need strings on heap, not statically allocated atoms, hence String.copy
*)
let (_:Thread.t) = Thread.create (fun () ->
  let i = ref 0 in 
  while true do Gc.compact(); incr i; if !i mod 100 = 0 then (print_char '.'; flush stdout) done) ()

let s = String.copy

let db = Mysql.quick_connect ~database:(s "test") ~user:(s "root") ()

let (_:Mysql.result) = Mysql.exec db (s "CREATE TABLE test(id INT, v VARCHAR(10)) ENGINE=MEMORY")
let () =
  let insert = P.create db (s "INSERT INTO test VALUES (?,?)") in
  for i = 10 to 15 do
    ignore (P.execute insert [|string_of_int i; sprintf "value %d" i|])
  done;
  for i = 16 to 20 do
    ignore (P.execute_null insert [|Some (string_of_int i); None|])
  done;
  P.close insert

let () =
  let rec loop t =
    match P.fetch t with
    | Some arr -> Array.iter (function Some s -> printf "%s " s | None -> print_string "<NULL> ") arr; print_endline ""; loop t
    | None -> ()
  in
  let select = P.create db (s "SELECT * FROM test WHERE id > ?") in
  print_endline "> 13";
  loop (P.execute select [|s "13"|]);
  print_endline "> 19";
  loop (P.execute select [|s "19"|]);
  print_endline "> 20";
  loop (P.execute select [|s "20"|]);
  P.close select;
  print_endline "done all";
  ()

let (_:Mysql.result) = Mysql.exec db (s "DROP TABLE test")

let () = Mysql.disconnect db
