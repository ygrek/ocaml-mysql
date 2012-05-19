let () =
  let ch = open_in "VERSION" in
  while true do
    let s = input_line ch in
    try
      Scanf.sscanf s " This is mysql, Version %s@ " print_endline;
      exit 0
    with
      _ -> ()
  done
