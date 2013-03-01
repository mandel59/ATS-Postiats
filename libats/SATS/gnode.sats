(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-2012 Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by the
** Free Software Foundation; either version 2.1, or (at your option)  any
** later version.
**
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
**
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)
//
// Author: Hongwei Xi (hwxi AT cs DOT bu DOT edu)
// Time: December, 2012
//
(* ****** ****** *)
//
// HX: generic nodes: singly-linked, doubly-linked, parental
//
(* ****** ****** *)

#define ATS_PACKNAME "ATSLIB.libats"
#define ATS_STALOADFLAG 0 // no need for staloading at run-time

(* ****** ****** *)

sortdef tk = tkind
sortdef t0p = t@ype and vt0p = vt@ype

(* ****** ****** *)
//
abstype
gnode (tk:tk, a:vt@ype+, l:addr) = ptr
//
typedef
gnode (tk:tk, a:vt0p) = [l:addr] gnode (tk, a, l)
typedef
gnode0 (tk:tk, a:vt0p) = [l:addr | l >= null] gnode (tk, a, l)
typedef
gnode1 (tk:tk, a:vt0p) = [l:addr | l >  null] gnode (tk, a, l)
//
(* ****** ****** *)

praxi
lemma_gnode
  {tk:tk}{a:vt0p}{l:addr} (nx: gnode (tk, a, l)): [l >= null] void
// end of [lemma_gnode]

(* ****** ****** *)

castfn
gnode2ptr {tk:tk}{a:vt0p}{l:addr} (nx: gnode (tk, a, l)):<> ptr (l)

(* ****** ****** *)

fun{
} gnode_null
  {tk:tk}{a:vt0p} ():<> gnode (tk, a, null)
// end of [gnode_null]

(* ****** ****** *)

fun{
tk:tk}{a:vt0p
} gnode_make_elt (x: a):<> gnode1 (tk, a)

(* ****** ****** *)

fun{
tk:tk}{a:t0p // [a] is nonlinear
} gnode_free (nx: gnode1 (tk, INV(a))):<!wrt> void

fun{
tk:tk}{a:vt0p
} gnode_free_elt
  (nx: gnode1 (tk, INV(a)), res: &(a?) >> a):<!wrt> void
// end of [gnode_free_elt]

(* ****** ****** *)

fun{
} gnode_is_null
  {tk:tk}{a:vt0p}{l:addr} (nx: gnode (tk, INV(a), l)):<> bool (l==null)
// end of [gnode_is_null]

fun{
} gnode_isnot_null
  {tk:tk}{a:vt0p}{l:addr} (nx: gnode (tk, INV(a), l)):<> bool (l > null)
// end of [gnode_isnot_null]

(* ****** ****** *)

fun{
tk:tk}{a:vt0p
} gnode_getref_elt (nx: gnode1 (tk, INV(a))):<> Ptr1

fun{
tk:tk}{a:vt0p
} gnode_getfree_elt (nx: gnode1 (tk, INV(a))):<> (a) // [nx] is freed

(* ****** ****** *)

fun{
tk:tk}{a:vt0p
} gnode_getref_next (nx: gnode1 (tk, INV(a))):<> Ptr1

fun{
tk:tk}{a:vt0p // implemented
} gnode_get_next (nx: gnode1 (tk, INV(a))):<> gnode0 (tk, a)
fun{
tk:tk}{a:vt0p // implemented
} gnode_set_next (nx: gnode1 (tk, INV(a)), nx2: gnode (tk, a)):<!wrt> void
fun{
tk:tk}{a:vt0p // implemented
} gnode0_set_next (nx: gnode0 (tk, INV(a)), nx2: gnode (tk, a)):<!wrt> void
fun{
tk:tk}{a:vt0p
} gnode_set_next_null (nx: gnode1 (tk, INV(a))):<!wrt> void
fun{
tk:tk}{a:vt0p
} gnode0_set_next_null (nx: gnode0 (tk, INV(a))):<!wrt> void

(* ****** ****** *)

fun{
tk:tk}{a:vt0p
} gnode_getref_prev (nx: gnode1 (tk, INV(a))):<> Ptr1

fun{
tk:tk}{a:vt0p
} gnode_get_prev (nx: gnode1 (tk, INV(a))):<> gnode0 (tk, a)
fun{
tk:tk}{a:vt0p
} gnode_set_prev (nx: gnode1 (tk, INV(a)), nx2: gnode (tk, a)):<!wrt> void
fun{
tk:tk}{a:vt0p
} gnode0_set_prev (nx: gnode0 (tk, INV(a)), nx2: gnode (tk, a)):<!wrt> void
fun{
tk:tk}{a:vt0p
} gnode_set_prev_null (nx: gnode1 (tk, INV(a))):<!wrt> void
fun{
tk:tk}{a:vt0p
} gnode0_set_prev_null (nx: gnode0 (tk, INV(a))):<!wrt> void

(* ****** ****** *)

fun{
tk:tk}{a:vt0p
} gnode_getref_parent (nx: gnode1 (tk, INV(a))):<> Ptr1

fun{
tk:tk}{a:vt0p
} gnode_get_parent (nx: gnode1 (tk, INV(a))):<> gnode0 (tk, a)
fun{
tk:tk}{a:vt0p
} gnode_set_parent (nx: gnode1 (tk, INV(a)), nx2: gnode (tk, a)):<!wrt> void
fun{
tk:tk}{a:vt0p
} gnode_set_parent_null (nx: gnode1 (tk, INV(a))):<!wrt> void
fun{
tk:tk}{a:vt0p
} gnode0_set_parent_null (nx: gnode0 (tk, INV(a))):<!wrt> void

(* ****** ****** *)

fun{
tk:tk}{a:vt0p
} gnode_getref_children (nx: gnode1 (tk, INV(a))):<> Ptr1

fun{
tk:tk}{a:vt0p
} gnode_get_children (nx: gnode1 (tk, INV(a))):<> gnode0 (tk, a)
fun{
tk:tk}{a:vt0p
} gnode_set_children (nx: gnode1 (tk, INV(a)), nx2: gnode (tk, a)):<!wrt> void

(* ****** ****** *)

fun{
tk:tk}{a:vt0p
} gnode_link (nx1: gnode1 (tk, INV(a)), nx2: gnode1 (tk, a)):<!wrt> void
fun{
tk:tk}{a:vt0p
} gnode_link00 (nx1: gnode0 (tk, INV(a)), nx2: gnode0 (tk, a)):<!wrt> void
fun{
tk:tk}{a:vt0p
} gnode_link01 (nx1: gnode0 (tk, INV(a)), nx2: gnode1 (tk, a)):<!wrt> void
fun{
tk:tk}{a:vt0p
} gnode_link10 (nx1: gnode1 (tk, INV(a)), nx2: gnode0 (tk, a)):<!wrt> void
fun{
tk:tk}{a:vt0p
} gnode_link11 (nx1: gnode1 (tk, INV(a)), nx2: gnode1 (tk, a)):<!wrt> void

(* ****** ****** *)

fun{
tk:tk}{a:vt0p
} gnode_cons {l:agz}
  (nx1: gnode (tk, INV(a), l), nx2: gnode0 (tk, a)):<!wrt> gnode (tk, a, l)
// end of [gnode_cons]

fun{
tk:tk}{a:vt0p
} gnode_snoc {l:agz}
  (nx1: gnode0 (tk, a), nx2: gnode (tk, INV(a), l)):<!wrt> gnode (tk, a, l)
// end of [gnode_snoc]

(* ****** ****** *)

fun{
tk:tk}{a:vt0p
} gnode_insert_next
  (nx1: gnode1 (tk, INV(a)), nx2: gnode1 (tk, a)):<!wrt> void
// end of [gnode_insert_next]

fun{
tk:tk}{a:vt0p
} gnode_insert_prev
  (nx1: gnode1 (tk, INV(a)), nx2: gnode1 (tk, a)):<!wrt> void
// end of [gnode_insert_prev]

(* ****** ****** *)

fun{
tk:tk}{a:vt0p
} gnode_remove (nx: gnode1 (tk, INV(a))):<!wrt> gnode1 (tk, a)
fun{
tk:tk}{a:vt0p
} gnode_remove_next (nx: gnode1 (tk, INV(a))):<!wrt> gnode0 (tk, a)
fun{
tk:tk}{a:vt0p
} gnode_remove_prev (nx: gnode1 (tk, INV(a))):<!wrt> gnode0 (tk, a)

(* ****** ****** *)

macdef
gnodelst_is_nil (nxs) = gnode_is_null (,(nxs))
macdef
gnodelst_is_cons (nxs) = gnode_isnot_null (,(nxs))

(* ****** ****** *)

fun{
tk:tk}{a:t0p
} gnodelst_free (nxs: gnode0 (tk, INV(a))):<!wrt> void

(* ****** ****** *)

fun{
tk:tk}{a:vt0p
} gnodelst_length (nxs: gnode0 (tk, INV(a))):<> intGte(0)

(* ****** ****** *)

fun{
tk:tk}{a:vt0p}{env:vt0p
} gnodelst_foreach$fwork (x: &a, env: &env >> _): void
fun{
tk:tk}{a:vt0p
} gnodelst_foreach (nx: gnode0 (tk, INV(a))): void
fun{
tk:tk}{a:vt0p}{env:vt0p
} gnodelst_foreach_env (nx: gnode0 (tk, INV(a)), env: &env >> _): void

(* ****** ****** *)

(* end of [gnode.sats] *)
