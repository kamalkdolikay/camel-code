let rec zip list1 list2 =
  match list1, list2 with
  | x::xs, y::ys -> (x, y) :: zip xs ys
  | _ -> []

let zip_to_string pairs =
  String.concat ", " (List.map (fun (x, y) -> "(" ^ x ^ ", " ^ y ^ ")") pairs)