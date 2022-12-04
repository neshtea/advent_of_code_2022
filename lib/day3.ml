type priority = int
type item = char
type rucksack = priority list * priority list

let explode s = List.init (String.length s) (String.get s)

(* Part 1 *)
module Char_map = Map.Make (Char)

let item_to_priority_map =
  let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" in
  let indexed = chars |> explode |> List.mapi (fun idx c -> (idx + 1, c)) in
  List.fold_left
    (fun m (prio, c) -> Char_map.add c prio m)
    Char_map.empty indexed

let priority_from_char c = Char_map.find c item_to_priority_map

let rucksack_from_line line =
  let len = List.length line in
  (* We assume only valid inputs :). *)
  let halve = len / 2 in
  ( Util.take halve line |> List.map priority_from_char,
    Util.drop halve line |> List.map priority_from_char )

exception Invalid_input

module PS = Set.Make (Int)

let same_in_both_compartments (left, right) =
  let intersection = PS.inter (PS.of_list left) (PS.of_list right) in
  match PS.cardinal intersection with
  | 1 -> PS.elements intersection |> List.hd
  | _ -> raise Invalid_input (* Don't care, just throw. *)

let sum_of_priorities rucksacks =
  List.map same_in_both_compartments rucksacks |> Util.sum

(* Part 2 *)
type team = rucksack * rucksack * rucksack

let priority_for_team (r1, r2, r3) =
  let to_set (a, b) = List.append a b |> PS.of_list in
  let inter = PS.inter (to_set r1) (to_set r2) |> PS.inter (to_set r3) in
  match PS.cardinal inter with
  | 1 -> PS.elements inter |> List.hd
  | _ -> raise Invalid_input

let build_teams rucksacks =
  let rec worker acc = function
    | [] -> acc
    | rs ->
        let group = Util.take 3 rs in
        let rest = Util.drop 3 rs in
        worker (group :: acc) rest
  in
  worker [] rucksacks
  |> List.map (function [ x; y; z ] -> (x, y, z) | _ -> raise Invalid_input)

let run file =
  let open Util.Infix in
  let rucksacks = Util.read_file_with file (rucksack_from_line -| explode) in
  ( rucksacks |> List.map same_in_both_compartments |> Util.sum,
    rucksacks |> build_teams |> List.map priority_for_team |> Util.sum )
