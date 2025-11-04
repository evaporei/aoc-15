let test_get_number () =
  let result = Eight.get_number () in
  assert (result = 42);
  print_endline "test_get_number: passed"

let () =
  test_get_number ()
