
open Printf
open Mysql

let db = quick_connect ~database:"test" ~user:"root" ()

let _ = exec db "CREATE TABLE IF NOT EXISTS test(id INT)"
let () =
  let insert = P.prepare db "INSERT INTO test VALUES (?)" in
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
  let select = P.prepare db "SELECT * FROM test WHERE id > ?" in
  print_endline "> 15";
  loop (P.execute select [|"15"|]);
  print_endline "> 20";
  loop (P.execute select [|"20"|]);
  print_endline "> 19";
  loop (P.execute select [|"19"|]);
  P.close select;
  print_endline "done all";
  ()

let _ = exec db "DROP TABLE test"

let () = disconnect db

