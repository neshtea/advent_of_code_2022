(* Part 1 *)
type food = int
type calories = int
type inventory = food list

let inventory_calories = List.fold_left (fun acc food -> acc + food) 0

(** [largest_inventory intentories] is the inventory in inventories with the 
    largest calory count. *)
let largest_inventory = function
  | [] -> None
  | i :: is ->
      is
      |> List.fold_left
           (fun max_inventory inventory ->
             inventory_calories inventory |> max max_inventory)
           (inventory_calories i)
      |> Option.some

type line = Food_line of int | Empty_line

exception Parse_error of string

(* Reads the inventories from the file and returns a list of inventories.
   Throws if the file is not found. *)
let read_inventory_file file =
  let ic = open_in file in
  let rec read_lines acc =
    match input_line ic with
    | "" -> read_lines (Empty_line :: acc)
    | s -> (
        match int_of_string_opt s with
        | None -> raise (Parse_error "not an integer")
        | Some i -> read_lines (Food_line i :: acc))
    | exception End_of_file -> acc
  in
  let inventories_of_lines =
    List.fold_left
      (fun (inventories, inventory) -> function
        | Food_line i -> (inventories, i :: inventory)
        | Empty_line -> (inventory :: inventories, []))
      ([], [])
  in
  read_lines [] |> inventories_of_lines

(* Part 2 *)

(** [rev_compare a b] is the inverted comparison of [Int.compare a b] *)
let rev_compare i1 i2 =
  match (i1 = i2, i1 < i2) with true, _ -> 0 | _, true -> 1 | _ -> -1

(** [top_three_elves inventories] returns the sum of calories carried by 
    the three elves with the larges bags. *)
let top_three_elves inventories =
  List.map inventory_calories inventories
  |> List.sort rev_compare |> Util.take 3
  |> List.fold_left (fun acc food -> acc + food) 0

let run input_file =
  let (inventories : food list list) = read_inventory_file input_file |> fst in
  (largest_inventory inventories, top_three_elves inventories)
