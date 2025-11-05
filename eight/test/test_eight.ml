let cases =
  [
    ("\"\"", (2, 0));
    ("\"abc\"", (5, 3));
    ("\"aaa\\\"aaa\"", (10, 7));
    ("\"\\x27\"", (6, 1));
  ]

let test_char_counts () =
  List.iter
    (fun (s, (exp_code, exp_mem)) ->
      let code, mem = Eight.char_counts s in
      assert (code = exp_code);
      assert (mem = exp_mem))
    cases;
  print_endline "test_char_counts: passed"

let () = test_char_counts ()
