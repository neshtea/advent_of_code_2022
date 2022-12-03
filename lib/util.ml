let compose f g x = g x |> f
let sum = List.fold_left ( + ) 0

let take n xs =
  (* NOTE: Why isn't this in the sdtlib?  Or did I just not find it? *)
  let rec worker n acc = function
    | [] -> acc
    | x :: xs -> if n = 0 then acc else worker (n - 1) (x :: acc) xs
  in
  worker n [] xs |> List.rev

let rec drop n = function
  | [] -> []
  | _ :: xs as lis -> if n = 0 then lis else drop (n - 1) xs

module Infix = struct
  let ( -| ) = compose
end

let read_file_with file f =
  let ic = open_in file in
  let rec read_lines acc =
    match input_line ic with
    | s -> read_lines (f s :: acc)
    | exception End_of_file -> acc
  in
  read_lines []
