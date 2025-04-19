open Bstree
open Zip

let html_template body = 
  "<!DOCTYPE html>" ^
  "<html>" ^
  "<head>" ^
  "<link rel='stylesheet' href='/static/style.css'>" ^
  "<script src='/static/tree.js' defer></script>" ^
  "</head>" ^
  "<body>" ^ body ^ "</body>" ^
  "</html>"

let rec tree_depth t =
  match t with
  | Leaf -> 0
  | Node (_, l, r) -> 1 + max (tree_depth l) (tree_depth r)

let () =
  Dream.run
  @@ Dream.router [
    Dream.get "/static/**" (Dream.static "static");
    
    (* Main page with choice between BST and Zip *)
    Dream.get "/" (fun _ ->
      Dream.html (
        html_template (
          "<h1>Choose Operation</h1>" ^
          "<a href='/bst'>Binary Search Tree Operations</a><br>" ^
          "<a href='/zip'>Zip Two Lists</a>"
        )
      ));

    (* BST Routes *)
    Dream.get "/bst" (fun req ->
      match Dream.query req "numbers" with
      | Some nums -> (
          try
            let numbers = 
              nums 
              |> String.split_on_char ',' 
              |> List.map String.trim
              |> List.map int_of_string 
            in
            let bst = bstree_of_list numbers in
            let size = bstree_size bst in
            let depth = tree_depth bst in
            let numbers_json = 
              "[" ^ (String.concat "," (List.map string_of_int numbers)) ^ "]"
            in
            let content = 
              "<h1>Binary Search Tree</h1>" ^
              "<div id='bst-data' style='display: none;'>" ^ numbers_json ^ "</div>" ^
              "<div id='bst-depth' style='display: none;'>" ^ string_of_int depth ^ "</div>" ^
              "<div id='bst-container'></div>" ^
              "<br>" ^
              "<button id='add-node-btn'>Add Node</button>" ^
              "<input type='number' id='new-node' placeholder='Enter node value' />" ^
              "<br>" ^
              "<button id='delete-node-btn'>Delete Node</button>" ^
              "<input type='number' id='delete-node' placeholder='Enter node value to delete' />" ^
              "<br>" ^
              "<p>Size: " ^ string_of_int size ^ "</p>" ^
              "<a href='/bst'>Back</a>"
            in
            Dream.html (html_template content)
          with
          | _ -> Dream.html (
              html_template (
                "<h1 class='error'>Error</h1>" ^
                "<p>Please enter valid numbers separated by commas</p>" ^
                "<a href='/bst'>Back</a>"
              )
            )
        )
      | None ->
          Dream.html (
            html_template (
              "<h1>Binary Search Tree Operations</h1>" ^
              "<form method='POST' action='/bst'>" ^
              "<input name='numbers' placeholder='e.g., 5,2,8,1,9' />" ^
              "<button type='submit'>Create BST</button>" ^
              "</form>" ^
              "<p>Enter numbers separated by commas</p>" ^
              "<a href='/'>Home</a>"
            )
          ));

    Dream.post "/bst" (fun req ->
      match%lwt Dream.form ~csrf:false req with
      | `Ok ["numbers", nums] -> (
          try
            let numbers = 
              nums 
              |> String.split_on_char ',' 
              |> List.map String.trim
              |> List.map int_of_string 
            in
            let bst = bstree_of_list numbers in
            let size = bstree_size bst in
            let depth = tree_depth bst in
            let numbers_json = 
              "[" ^ (String.concat "," (List.map string_of_int numbers)) ^ "]"
            in
            let content = 
              "<h1>Binary Search Tree</h1>" ^
              "<div id='bst-data' style='display: none;'>" ^ numbers_json ^ "</div>" ^
              "<div id='bst-depth' style='display: none;'>" ^ string_of_int depth ^ "</div>" ^
              "<div id='bst-container'></div>" ^
              "<br>" ^
              "<button id='add-node-btn'>Add Node</button>" ^
              "<input type='number' id='new-node' placeholder='Enter node value' />" ^
              "<br>" ^
              "<button id='delete-node-btn'>Delete Node</button>" ^
              "<input type='number' id='delete-node' placeholder='Enter node value to delete' />" ^
              "<br>" ^
              "<p>Size: " ^ string_of_int size ^ "</p>" ^
              "<a href='/bst'>Back</a>"
            in
            Dream.html (html_template content)
          with
          | _ -> Dream.html (
              html_template (
                "<h1 class='error'>Error</h1>" ^
                "<p>Please enter valid numbers separated by commas</p>" ^
                "<a href='/bst'>Back</a>"
              )
            )
        )
      | _ -> Dream.html (
          html_template (
            "<h1 class='error'>Error</h1><p>Invalid input!</p><a href='/bst'>Back</a>"
          )
        ));

    Dream.post "/bst/delete" (fun req ->
      match%lwt Dream.form ~csrf:false req with
      | `Ok ["delete_num", num_str; "numbers", nums] -> (
          try
            let n = int_of_string num_str in
            let numbers = 
              nums 
              |> String.split_on_char ',' 
              |> List.map String.trim
              |> List.map int_of_string 
            in
            let bst = bstree_of_list numbers in
            let new_bst = bstree_delete n bst in
            let new_numbers = 
              let rec to_list t =
                match t with
                | Leaf -> []
                | Node (v, l, r) -> (to_list l) @ [v] @ (to_list r)
              in
              to_list new_bst
            in
            let new_nums_str = String.concat "," (List.map string_of_int new_numbers) in
            Dream.redirect req ("/bst?numbers=" ^ new_nums_str)
          with
          | _ -> Dream.html (
              html_template (
                "<h1 class='error'>Error</h1><p>Invalid number!</p><a href='/bst'>Back</a>"
              )
            )
        )
      | _ -> Dream.html (
          html_template (
            "<h1 class='error'>Error</h1><p>Invalid input!</p><a href='/bst'>Back</a>"
          )
        ));

    (* Zip Routes *)
    Dream.get "/zip" (fun _ ->
      Dream.html (
        html_template (
          "<h1>Zip Two Lists</h1>" ^
          "<form method='POST' action='/zip'>" ^
          "<input name='list1' placeholder='e.g., a,b,c' />" ^
          "<input name='list2' placeholder='e.g., 1,2,3' />" ^
          "<button type='submit'>Zip!</button>" ^
          "</form>" ^
          "<a href='/'>Home</a>"
        )
      ));

    Dream.post "/zip" (fun req ->
      match%lwt Dream.form ~csrf:false req with
      | `Ok ["list1", l1; "list2", l2] ->
          let list1 = String.split_on_char ',' l1 |> List.map String.trim in
          let list2 = String.split_on_char ',' l2 |> List.map String.trim in
          let result = zip list1 list2 in
          let result_html = 
            "<h1>Zipped Result</h1>" ^
            "<p>Result: " ^ zip_to_string result ^ "</p>" ^
            "<a href='/zip'>Back</a>"
          in
          Dream.html (html_template result_html)
      | _ -> Dream.html (
          html_template (
            "<h1 class='error'>Error</h1><p>Invalid input! Please enter two comma-separated lists</p><a href='/zip'>Back</a>"
          )
        ))
  ]