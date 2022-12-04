val compose : ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c
(** [compose f g] is the right to left composition of both functions. *)

val sum : int list -> int
(** [sum is] is the sum of all ints in [is]. *)

val take : int -> 'a list -> 'a list
(** [take n xs] is the list that contains the first [n] elements of [xs].
    If [xs] contains less than [n] elements, returns the whole list.*)

val drop : int -> 'a list -> 'a list
(** [drop n xs] is the list xs with the first n elements removed.
    If [xs] contains less than [n] elements, returns the empty list.*)

module Infix : sig
  val ( -| ) : ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c
  (** [f -| g] Infix version of [compose f g] *)
end

val read_file_with : string -> (string -> 'a) -> 'a list
(** [read_file_with file_path f] is the list of all lines in the file with f 
    applied to the line. *)

val range : int -> int -> int list
(** [range from to] returns the list of integers between from and to, including
    both.  If from is greater than two, returns the empty list. *)

val uncurry : ('a -> 'b -> 'c) -> 'a * 'b -> 'c
(** [uncurry f] is the function f that takes a two-tuple of arguments instead
    of two arguments *)
