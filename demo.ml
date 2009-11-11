(*
    $Id: demo.ml 1.1 Thu, 23 Feb 2006 14:13:22 -0800 shawnw $

    Simple demo for the Mysql module.
*)

open Mysql

(* login informations *)

let db = quick_connect ~database:"test"  ()
    
let table       =
                [ ("one"    , 1, 1.0)
                ; ("two"    , 2, 2.0)
                ; ("three"  , 3, 3.0)
                ; (",':-"   , 4, 4.0)
                ]


let mk_table () =
    let _r = exec db "create table caml (a char(64), b int, c float)"     in
        db

let fill_table c =
    let ml2values (a,b,c) = values [ml2str a; ml2int b; ml2float c]     in
    let insert values     = "insert into caml values " ^ values         in
    let rec loop = function
        | []    -> ()
        | x::xs -> ( ignore (exec c (insert (ml2values x)))
                   ; loop xs
                   )                                                    
    in
        loop table
        
let read_table c =
    let r                   = exec c "select * from caml" in
    let col                 = column r                              in
    let row x               = ( not_null str2ml   (col ~key:"a" ~row:x)
                              , not_null int2ml   (col ~key:"b" ~row:x)
                              , not_null float2ml (col ~key:"c" ~row:x)
                              )                                     in
    let rec loop = function
        | None      -> []
        | Some x    -> row x :: loop (fetch r)
    in
        loop (fetch r)


let main () =
    let c = mk_table ()         in
        ( fill_table c
        ; ignore (read_table c)
        ; ignore (exec c "drop table caml")
        ; disconnect c
        )


let _ = Printexc.print main ()
