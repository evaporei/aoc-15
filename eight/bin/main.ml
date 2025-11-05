let () =
  let ic = open_in "example" in
  try
    while true do
      let line = input_line ic in
      let code, mem = Eight.char_counts line in
      Printf.printf "The number is: %d, %d\n" code mem
    done
  with End_of_file -> close_in ic
