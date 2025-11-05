let char_counts s =
  let code = String.length s in
  let mem = ref 0 in
  let i = ref 0 in
  while !i < code do
    let jump =
      match String.get s !i with
      | '\\' -> (
          match String.get s (!i + 1) with '"' | '\\' -> 2 | 'x' -> 4 | _ -> 1)
      | _ -> 1
    in
    mem := !mem + 1;
    i := !i + jump
  done;
  (code, !mem - 2)

let decode s =
  let code = String.length s in
  let mem = ref 0 in
  let i = ref 0 in
  while !i < code do
    let double = match String.get s !i with '\\' | '"' -> 2 | _ -> 1 in
    mem := !mem + double;
    i := !i + 1
  done;
  !mem + 2
