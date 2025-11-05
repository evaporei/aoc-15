let () =
  let ic = open_in "input" in
  let rec aux acc =
    try
      let line = input_line ic in
      let code, mem = Eight.char_counts line in
      (* Printf.printf "The number is: %d, %d\n" code mem *)
      aux (acc + code - mem)
    with End_of_file ->
      close_in ic;
      acc
  in
  Printf.printf "%d\n" (aux 0)
