(*
** for testing [prelude/string]
*)

(* ****** ****** *)

staload "prelude/DATS/basics.dats"

staload "prelude/DATS/integer.dats"
staload "prelude/DATS/pointer.dats"

staload "prelude/DATS/char.dats"

staload "prelude/DATS/string.dats"

(* ****** ****** *)

staload _ = "prelude/DATS/unsafe.dats"

(* ****** ****** *)

staload UN = "prelude/SATS/unsafe.sats"

(* ****** ****** *)

val alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

(* ****** ****** *)

val () = {
//
val ab = alphabet
val () = assertloc (ab[0] = 'A')
val () = assertloc (ab[1] = 'B')
val () = assertloc (ab[2] = 'C')
val () = assertloc (ab[23] = 'X')
val () = assertloc (ab[24] = 'Y')
val () = assertloc (ab[25] = 'Z')
val () = assertloc (compare (ab, ab) = 0)
val () = assertloc (strlen (ab) = 26)
val () = assertloc (string_length (ab) = 26)
//
} // end of [val]

(* ****** ****** *)

val () = {
//
val ab = alphabet
//
val () = assertloc (strchr (ab, 'a') < 0)
val () = assertloc (strrchr (ab, 'a') < 0)
val () = assertloc (strchr (ab, 'A') = 0)
val () = assertloc (strrchr (ab, 'A') = 0)
val () = assertloc (strchr (ab, 'Z') = 25)
val () = assertloc (strrchr (ab, 'Z') = 25)
val () = assertloc (strchr (ab, '\0') = 26)
val () = assertloc (strrchr (ab, '\0') = 26)
//
val () = assertloc (strstr (ab, "PQR") = strchr (ab, 'P'))
val () = assertloc (strspn (ab, "ABC") = 3)
val () = assertloc (strcspn (ab, "XYZ") = 23)
//
val () = assertloc (string_index (ab, 'P') = 15)
val () = assertloc (string_rindex (ab, 'P') = 15)
//
} // end of [val]

(* ****** ****** *)

val () = {
//
val ab = alphabet
val ab2 = string0_copy (ab)
val () = assertloc (ab = $UN.strptr2string (ab2))
val () = strptr_free (ab2)
val abab = string0_append (ab, ab)
val () = assertloc (strstr ($UN.strptr2string (abab), ab) = 0)
val () = assertloc (strrchr ($UN.strptr2string (abab), 'A') = 26)
val () = assertloc (strrchr ($UN.strptr2string (abab), 'B') = 27)
val () = assertloc (strrchr ($UN.strptr2string (abab), 'C') = 28)
val () = strptr_free (abab)
//
} // end of [val]

(* ****** ****** *)

val () = {
//
val ab = alphabet
//
implement{}
string_tabulate$fwork (i) = let
  val c = int2char0 (char2int0('A') + g0u2i(i))
in
  $UN.cast{charNZ}(c) // HX: [c] cannot be NUL
end // end of [string_tabulate$fwork]
//
val ab2 = string_tabulate (i2sz(26))
val () = assertloc (ab = string_of_strnptr (ab2))
//
} // end of [val]

(* ****** ****** *)

implement main0 () = ()

(* ****** ****** *)

(* end of [prelude_string.dats] *)