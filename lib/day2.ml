(* Utilities *)
let split_line l = (String.get l 0, String.get l 2)

let split_line_with f g l =
  let left, right = split_line l in
  (f left, g right)

(* Part 1 *)
type move = Rock | Paper | Scissors

exception Invalid_move of char

let move_from_opponent_code = function
  | 'A' -> Rock
  | 'B' -> Paper
  | 'C' -> Scissors
  | s -> raise (Invalid_move s)

let move_from_player_code = function
  | 'X' -> Rock
  | 'Y' -> Paper
  | 'Z' -> Scissors
  | s -> raise (Invalid_move s)

type outcome = Lose | Draw | Win
type score = int

let score_for_move = function Rock -> 1 | Paper -> 2 | Scissors -> 3
let score_for_outcome = function Lose -> 0 | Draw -> 3 | Win -> 6

type game_result = move * outcome

let score_for_game_result (move, outcome) =
  score_for_move move + score_for_outcome outcome

let player_outcome = function
  | Rock, Paper -> Win
  | Rock, Scissors -> Lose
  | Paper, Scissors -> Win
  | Paper, Rock -> Lose
  | Scissors, Rock -> Win
  | Scissors, Paper -> Lose
  | _ -> Draw

let game_result_from_move_instruction (opponent_move, player_move) =
  (player_move, player_outcome (opponent_move, player_move))

(* Part 2 *)

(* Given a tuple of (oppenent move, resired outcome), returns the move the
   player needs to make to achieve the desired outcome. *)
let move_from_recommendation = function
  | Rock, Win -> Paper
  | Rock, Lose -> Scissors
  | Paper, Win -> Scissors
  | Paper, Lose -> Rock
  | Scissors, Win -> Rock
  | Scissors, Lose -> Paper
  | move, _ -> move

let desired_result_from_code = function
  | 'X' -> Lose
  | 'Y' -> Draw
  | 'Z' -> Win
  | s -> raise (Invalid_move s)

let read_file_part_1 file =
  split_line_with move_from_opponent_code move_from_player_code
  |> Util.read_file_with file

let part_1 file =
  let open Util.Infix in
  read_file_part_1 file
  |> List.map (score_for_game_result -| game_result_from_move_instruction)
  |> Util.sum

let read_file_part_2 file =
  split_line_with move_from_opponent_code desired_result_from_code
  |> Util.read_file_with file

let game_result_from_move_instruction_2 (opponent_move, desired_result) =
  (move_from_recommendation (opponent_move, desired_result), desired_result)

let part_2 file =
  let open Util.Infix in
  read_file_part_2 file
  |> List.map (score_for_game_result -| game_result_from_move_instruction_2)
  |> Util.sum

let run file = (part_1 file, part_2 file)
