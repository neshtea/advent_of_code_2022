type section = int
type range = section * section
type pair = range * range

module IS = Set.Make (Int)

let set_range start end_ = Util.range start end_ |> IS.of_list

let fully_contains (start1, end1) (start2, end2) =
  let s1, s2 = (set_range start1 end1, set_range start2 end2) in
  IS.diff s1 s2 |> IS.is_empty || IS.diff s2 s1 |> IS.is_empty

let overlaps (start1, end1) (start2, end2) =
  let s1, s2 = (set_range start1 end1, set_range start2 end2) in
  let not_empty s = 0 < IS.cardinal s in
  IS.inter s1 s2 |> not_empty || IS.inter s2 s1 |> not_empty

exception Illegal_argument

let read_input file =
  Util.read_file_with file (fun s ->
      let line_list =
        String.split_on_char ',' s
        |> List.map (fun range_string ->
               match String.split_on_char '-' range_string with
               | from :: to_ :: _ -> (int_of_string from, int_of_string to_)
               | _ -> raise Illegal_argument)
      in
      match line_list with a :: b :: _ -> (a, b) | _ -> raise Illegal_argument)

let int_from_bool = function true -> 1 | false -> 0

let run file =
  let open Util.Infix in
  let input = read_input file in
  ( List.map (int_from_bool -| Util.uncurry fully_contains) input |> Util.sum,
    List.map (int_from_bool -| Util.uncurry overlaps) input |> Util.sum )
