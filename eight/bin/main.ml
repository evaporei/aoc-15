let () =
  let ic = open_in "input" in
  let rec aux pt1 pt2 =
    try
      let line = input_line ic in
      let code, mem = Eight.char_counts line in
      let decoded = Eight.decode line in
      (* Printf.printf "%d, %d, %d\n" code mem decoded; *)
      aux (pt1 + code - mem) (pt2 + decoded - code)
    with End_of_file ->
      close_in ic;
      (pt1, pt2)
  in
  let pt1, pt2 = aux 0 0 in
  Printf.printf "%d\n%d\n" pt1 pt2
