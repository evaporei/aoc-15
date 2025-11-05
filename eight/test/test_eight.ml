let cases =
  [
    ("\"\"", (2, 0, 6));
    ("\"abc\"", (5, 3, 9));
    ("\"aaa\\\"aaa\"", (10, 7, 16));
    ("\"\\x27\"", (6, 1, 11));
  ]

let test_char_counts () =
  List.iter
    (fun (s, (exp_code, exp_mem, _)) ->
      let code, mem = Eight.char_counts s in
      assert (code = exp_code);
      assert (mem = exp_mem))
    cases;
  print_endline "test_char_counts: passed"

let test_decode () =
  List.iter
    (fun (s, (_, _, exp_decoded)) ->
      let decoded = Eight.decode s in
      assert (decoded = exp_decoded))
    cases;
  print_endline "test_decode: passed"

let () =
  test_char_counts ();
  test_decode ()
