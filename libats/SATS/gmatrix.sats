(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-2013 Hongwei Xi, ATS Trustful Software, Inc.
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

(* Author: Hongwei Xi *)
(* Authoremail: hwxi AT cs DOT bu DOT edu *)
(* Start time: July, 2013 *)

(* ****** ****** *)

staload "libats/SATS/gvector.sats"

(* ****** ****** *)
//
datasort mord =
  | mrow (* row major *)
  | mcol (* column major *)
datatype MORD (mord) =
  | MORDrow (mrow) of () | MORDcol (mcol) of ()
//
(* ****** ****** *)
//
// HX-2013-07:
// generic matrix:
// element, row, col, ord, ld
//
abst@ype
gmatrix_t0ype
  (a:t@ype+, mo:mord, m:int, n:int, ld:int) (* irregular *)
//
typedef gmatrix
  (a:t@ype, mo:mord, m:int, n:int, ld:int) = gmatrix_t0ype (a, mo, m, n, ld)
viewdef gmatrix_v
  (a:t0p, mo:mord, l:addr, m:int, n:int, ld:int) = gmatrix_t0ype (a, mo, m, n, ld) @ l
//
stadef GMX = gmatrix
stadef GMX_v = gmatrix_v
//
(* ****** ****** *)

praxi
lemma_gmatrow_param
  {a:t0p}{m,n:int}{ld:int}
  (M: &gmatrow (a, m, n, ld)): [m >= 0; n >= 1; ld >= n] void
praxi
lemma_gmatrow_v_param
  {a:t0p}{l:addr}{m,n:int}{ld:int}
  (pf: !gmatrow_v (a, l, m, n, ld)): [m >= 0; n >= 1; ld >= n] void

(* ****** ****** *)
//
typedef gmatrow
  (a:t@ype, m:int, n:int, ld:int) = gmatrix_t0ype (a, mrow, m, n, ld)
viewdef gmatrow_v
  (a:t@ype, l:addr, m:int, n:int, ld:int) = gmatrix_t0ype (a, mrow, m, n, ld) @ l
//
stadef GMR = gmatrow
stadef GMR_v = gmatrow_v
//
typedef gmatcol
  (a:t@ype, m:int, n:int, ld:int) = gmatrix_t0ype (a, mcol, m, n, ld)
viewdef gmatcol_v
  (a:t@ype, l:addr, m:int, n:int, ld:int) = gmatrix_t0ype (a, mcol, m, n, ld) @ l
//
stadef GMC = gmatcol
stadef GMC_v = gmatcol_v
//
(* ****** ****** *)

praxi
lemma_gmatcol_param
  {a:t0p}{m,n:int}{ld:int}
  (M: &gmatcol (a, m, n, ld)): [m >= 1; n >= 0; ld >= m] void
praxi
lemma_gmatcol_v_param
  {a:t0p}{l:addr}{m,n:int}{ld:int}
  (pf: !gmatcol_v (a, l, m, n, ld)): [m >= 1; n >= 0; ld >= m] void

(* ****** ****** *)
//
// BB: outer product
// BB: tensor product
//
//
fun{a:t0p}
multo_gvector_gvector_gmatrow
  {m,n:int}{d1,d2:int}{ld3:int}
(
  V1: &GV (INV(a), m, d1), V2: &GV (a , n, d2)
, M3: &GMR (a?, m, n, ld3) >> GMR (a, m, n, ld3)
, m: int(m), n: int(n), d1: int(d1), d2: int(d2), ld3: int(ld3)
) : void (* end of [mulo_gvector_gvector_gmatrow] *)

(* ****** ****** *)

fun{
a:t0p
} multo_gmatrix_gmatrix_gmatrix
  {mo:mord}{p,q,r:int}{lda,ldb,ldc:int}
(
  A: &GMX (INV(a), mo, p, q, lda)
, B: &GMX (    a , mo, q, r, ldb)
, C: &GMX (    a?, mo, p, r, ldc) >> GMX (a, mo, p, r, ldc)
, MORD (mo), int p, int q, int r, int lda, int ldb, int ldc
) : void // end of [multo_gmatrix_gmatrix_gmatrix]

fun{
a:t0p
} multo_gmatrow_gmatrow_gmatrow
  {p,q,r:int}{lda,ldb,ldc:int}
(
  A: &GMR (INV(a), p, q, lda)
, B: &GMR (    a , q, r, ldb)
, C: &GMR (a?, p, r, ldc) >> GMR (a, p, r, ldc)
, int p, int q, int r, int lda, int ldb, int ldc
) : void // end of [multo_gmatrow_gmatrow_gmatrow]

fun{
a:t0p
} multo_gmatcol_gmatcol_gmatcol
  {p,q,r:int}{lda,ldb,ldc:int}
(
  A: &GMC (INV(a), p, q, lda)
, B: &GMC (    a , q, r, ldb)
, C: &GMC (a?, p, r, ldc) >> GMC (a, p, r, ldc)
, int p, int q, int r, int lda, int ldb, int ldc
) : void // end of [multo_gmatcol_gmatcol_gmatcol]

(* ****** ****** *)

(* end of [gmatrix.sats] *)