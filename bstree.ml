type 'a bstree = Leaf | Node of 'a * 'a bstree * 'a bstree

let bstree_empty = Leaf

let bstree_is_empty t = t = Leaf

let rec bstree_size t =
  match t with
  | Leaf -> 0
  | Node (_, l, r) -> 1 + bstree_size l + bstree_size r

let rec bstree_insert x t =
  match t with
  | Leaf -> Node (x, Leaf, Leaf)
  | Node (v, l, r) when x < v ->
      Node (v, bstree_insert x l, r)
  | Node (v, l, r) when x > v ->
      Node (v, l, bstree_insert x r)
  | _ -> t

let bstree_of_list l =
  List.fold_left (Fun.flip bstree_insert) bstree_empty l

let rec bstree_mem x t =
  match t with
  | Leaf -> false
  | Node (v, l, _) when x < v ->
      bstree_mem x l
  | Node (v, _, r) when x > v ->
      bstree_mem x r
  | _ -> true

let rec bstree_max t =
  match t with
  | Leaf -> failwith "bstree_max: empty tree"
  | Node (v, _, Leaf) -> v
  | Node (_, _, r) -> bstree_max r

let rec bstree_delete x t =
  match t with
  | Leaf -> Leaf
  | Node (v, l, r) when x < v ->
      Node (v, bstree_delete x l, r)
  | Node (v, l, r) when x > v ->
      Node (v, l, bstree_delete x r)
  | Node (_, l, Leaf) -> l
  | Node (_, Leaf, r) -> r
  | Node (_, l, r) ->
      let max = bstree_max l in
      Node (max, bstree_delete max l, r)

let rec bstree_to_string t =
  match t with
  | Leaf -> ""
  | Node (v, l, r) ->
      let left = bstree_to_string l in
      let right = bstree_to_string r in
      let current = string_of_int v in
      String.concat ", " (List.filter ((<>) "") [left; current; right])