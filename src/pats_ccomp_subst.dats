(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of  the GNU GENERAL PUBLIC LICENSE (GPL) as published by the
** Free Software Foundation; either version 3, or (at  your  option)  any
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
// Author: Hongwei Xi (gmhwxi AT gmail DOT com)
// Start Time: November, 2012
//
(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/list.dats"
staload _(*anon*) = "prelude/DATS/list_vt.dats"

(* ****** ****** *)

staload "./pats_basics.sats"

(* ****** ****** *)

staload "./pats_errmsg.sats"
staload _(*anon*) = "./pats_errmsg.dats"
implement prerr_FILENAME<> () = prerr "pats_ccomp_subst"

(* ****** ****** *)

staload ERR = "./pats_error.sats"

(* ****** ****** *)

staload "pats_staexp2.sats"
staload "pats_staexp2_util.sats"

(* ****** ****** *)

staload "pats_histaexp.sats"

(* ****** ****** *)

staload "pats_ccomp.sats"

(* ****** ****** *)

local

fun auxlst (
  loc0: location
, sub: !stasub, xs: t2mpmarglst
) : t2mpmarglst = let
in
//
case+ xs of
| list_cons
    (x, xs) => let
    val s2es = x.t2mpmarg_arg
    val s2es2 =
      s2explst_subst (sub, s2es)
    val x2 = t2mpmarg_make (loc0, s2es2)
    val xs2 = auxlst (loc0, sub, xs)
  in
    list_cons (x2, xs2)
  end // end of [list_cons]
| list_nil () => list_nil ()
//
end // end of [auxlst]

in // in of [local]

implement
t2mpmarglst_subst
  (loc0, sub, t2mas) = auxlst (loc0, sub, t2mas)
// end of [t2mpmarglst_subst]

end // end of [local]

(* ****** ****** *)

implement
t2mpmarglst_tsubst
  (loc0, tsub, t2mas) = let
//
val sub = tmpsub2stasub (tsub)
val t2mas2 = t2mpmarglst_subst (loc0, sub, t2mas)
val () = stasub_free (sub)
in
  t2mas2
end // end of [t2mpmarglst_tsubst]

(* ****** ****** *)
//
extern
fun tmpvar_subst
  (sub: !stasub, tmp: tmpvar, sfx: int): tmpvar
extern
fun tmpvarlst_subst
  (sub: !stasub, tmplst: tmpvarlst, sfx: int): tmpvarlst
//
(* ****** ****** *)

local

extern
fun tmpvar_set_origin (
  tmp: tmpvar, opt: tmpvaropt
) : void  = "patsopt_tmpvar_set_origin"
extern
fun tmpvar_set_suffix
  (tmp: tmpvar, sfx: int): void = "patsopt_tmpvar_set_suffix"
// end of [tmpvar_set_suffix]

in // in of [local]

implement
tmpvar_subst
  (sub, tmp, sfx) = let
  val loc = tmpvar_get_loc (tmp)
  val hse = tmpvar_get_type (tmp)
  val hse = hisexp_subst (sub, hse)
  val tmp2 = tmpvar_make (loc, hse)
  val () =
    tmpvar_set_origin (tmp2, Some (tmp))
  // end of [val]
  val () = tmpvar_set_suffix (tmp2, sfx)
in
  tmp2
end // end of [tmpvar_subst]

end // end of [local]

(* ****** ****** *)

implement
tmpvarlst_subst
  (sub, tmplst, sfx) = let
//
fun loop (
  sub: !stasub
, xs: tmpvarlst, sfx: int, ys: tmpvarlst_vt
) : tmpvarlst_vt = let
//
in
//
case+ xs of
| list_cons
    (x, xs) => let
    val y = tmpvar_subst (sub, x, sfx)
  in
    loop (sub, xs, sfx, list_vt_cons (y, ys))
  end // end of [list_cons]
| list_nil () => ys
//
end // end of [loop]
//
val tmplst2 =
  loop (sub, tmplst, sfx, list_vt_nil)
val tmplst2 = list_vt_reverse (tmplst2)
//
in
  list_of_list_vt (tmplst2)
end // end of [tmpvarlst_subst]

(* ****** ****** *)

vtypedef tmpmap = tmpvarmap_vt (tmpvar)

(* ****** ****** *)
//
extern
fun primval_subst (
  env: !ccompenv, map: !tmpmap, sub: !stasub, pmv: primval, sfx: int
) : primval // end of [primval_subst]
extern
fun primvalist_subst (
  env: !ccompenv, map: !tmpmap, sub: !stasub, pmvs: primvalist, sfx: int
) : primvalist // end of [primvalist_subst]
//
extern
fun instr_subst
  (env: !ccompenv, map: !tmpmap, sub: !stasub, ins: instr, sfx: int): instr
extern
fun instrlst_subst
  (env: !ccompenv, map: !tmpmap, sub: !stasub, inss: instrlst, sfx: int): instrlst
//
(* ****** ****** *)

implement
funlab_subst
  (sub, flab) = let
//
val name = funlab_get_name (flab)
val level = funlab_get_level (flab)
val hse = funlab_get_type (flab)
val hse2 = hisexp_subst (sub, hse)
val () = println! ("funlab_subst: hse2 = ", hse2)
val qopt = funlab_get_qopt (flab)
val t2mas = funlab_get_tmparg (flab)
val stamp = $STMP.funlab_stamp_make ()
//
in
//
funlab_make (name, level, hse2, qopt, t2mas, stamp)
//
end // end of [funlab_subst]

(* ****** ****** *)

extern
fun tmpmap_make (xs: tmpvarlst): tmpmap
implement
tmpmap_make (xs) = let
//
fun loop (
  xs: tmpvarlst, res: &tmpmap
) : void = let
in
//
case+ xs of
| list_cons
    (x, xs) => let
    val- Some (xp) = tmpvar_get_origin (x)
    val _(*inserted*) = tmpvarmap_vt_insert (res, xp, x)
  in
    loop (xs, res)
  end // end of [list_cons]
| list_nil () => ()
//
end // end of [loop]
//
var res
  : tmpmap = tmpvarmap_vt_nil ()
val () = loop (xs, res)
//
in
  res
end // end of [tmpmap_make]

(* ****** ****** *)

implement
funent_subst
  (env, sub, flab2, fent, sfx) = let
//
val loc = funent_get_loc (fent)
val flab = funent_get_lab (fent)
val level = funent_get_level (fent)
//
val imparg = funent_get_imparg (fent)
val tmparg = funent_get_tmparg (fent)
val tmpret = funent_get_tmpret (fent)
val inss = funent_get_instrlst (fent)
val tmplst = funent_get_tmpvarlst (fent)
//
val tmplst2 = tmpvarlst_subst (sub, tmplst, sfx)
val tmpmap2 = tmpmap_make (tmplst2)
//
val inss2 = instrlst_subst (env, tmpmap2, sub, inss, sfx)
//
val ((*void*)) = tmpvarmap_vt_free (tmpmap2)
//
val fent2 =
  funent_make (
  loc, level, flab2, imparg, tmparg, None(), tmpret, inss2, tmplst2
) // end of [val]
//
in
  fent2
end // end of [funent_subst]

(* ****** ****** *)

extern
fun tmpvar2tmpvar
  (map: !tmpmap, tmp: tmpvar): tmpvar
implement
tmpvar2tmpvar
  (map, tmp) = let
  val opt = tmpvarmap_vt_search (map, tmp)
in
//
case+ opt of
| ~Some_vt (tmp2) => tmp2
| ~None_vt () => let
    val () = prerr_interror ()
    val () = prerr ": tmpvar2tmpvar: copy is not found: tmp = "
    val () = prerr_tmpvar (tmp)
  in
    $ERR.abort ()
  end // end of [None_vt]
//
end // end of [tmpvar2tmpvar]

(* ****** ****** *)

implement
primval_subst (
  env, map, sub, pmv0, sfx
) = let
//
val loc0 = pmv0.primval_loc
val hse0 = pmv0.primval_type
val hse0 = hisexp_subst (sub, hse0)
//
macdef ftmp (x) = tmpvar2tmpvar (map, ,(x))
macdef fpmv (x) = primval_subst (env, map, sub, ,(x), sfx)
macdef fpmvlst (xs) = primvalist_subst (env, map, sub, ,(xs), sfx)
//
in
//
case+
  pmv0.primval_node of
//
| PMVtmp (tmp) => let
    val tmp = ftmp (tmp) in primval_tmp (loc0, hse0, tmp)
  end // end of [PMVtmp]
//
| PMVarg (n) => primval_arg (loc0, hse0, n)
//
| PMVtmpltcst
    (d2c, t2mas) => let
    val t2mas = t2mpmarglst_subst (loc0, sub, t2mas)
    val tmpmat = ccompenv_tmpcst_match (env, d2c, t2mas)
  in
    ccomp_tmpcstmat (env, loc0, hse0, d2c, t2mas, tmpmat)
  end // end of [PMVtmpltcst]
//
| _ => pmv0
//
end // end of [primval_subst]

(* ****** ****** *)

implement
primvalist_subst (
  env, map, sub, pmvs, sfx
) = let
in
//
case+ pmvs of
| list_cons
    (pmv, pmvs) => let
    val pmv = primval_subst (env,map, sub, pmv, sfx)
    val pmvs = primvalist_subst (env,map, sub, pmvs, sfx)
  in
    list_cons (pmv, pmvs)
  end // end of [list_cons]
| list_nil () => list_nil ()
//
end // end of [primvalist_subst]

(* ****** ****** *)

implement
instr_subst (
  env, map, sub, ins0, sfx
) = let
//
val loc0 = ins0.instr_loc
//
macdef ftmp (x) = tmpvar2tmpvar (map, ,(x))
macdef fpmv (x) = primval_subst (env, map, sub, ,(x), sfx)
macdef fpmvlst (xs) = primvalist_subst (env, map, sub, ,(xs), sfx)
//
in
//
case+
  ins0.instr_node of
//
| INSfunlab _ => ins0
//
| INSmove_val
    (tmp, pmv) => let
    val tmp = ftmp (tmp)
    val pmv = fpmv (pmv)
  in
    instr_move_val (loc0, tmp, pmv)
  end // end of [INSmove_val]
(*
| INSmove_arg_val of (int(*arg*), primval)
| INSmove_ptr_val of (tmpvar(*ptr*), primval)
//
| INSmove_con of
    (tmpvar, d2con, hisexp, primvalist(*arg*))
| INSmove_ptr_con of
    (tmpvar(*ptr*), d2con, hisexp, primvalist(*arg*))
//
| INSTRmove_rec_box of
    (tmpvar, labprimvalist(*arg*), hisexp)
| INSTRmove_rec_flt of
    (tmpvar, labprimvalist(*arg*), hisexp)
//
| INSmove_list_nil of (tmpvar) // tmp <- list_nil
| INSpmove_list_nil of (tmpvar) // *tmp <- list_nil
| INSpmove_list_cons of (tmpvar) // *tmp <- list_cons
| INSupdate_list_head of // hd <- &(tl->val)
    (tmpvar(*hd*), tmpvar(*tl*), hisexp(*elt*))
| INSupdate_list_tail of // tl_new <- &(tl_old->next)
    (tmpvar(*new*), tmpvar(*old*), hisexp(*elt*))
//
| INSmove_arrpsz of
    (tmpvar, hisexp(*elt*), int(*asz*))
| INSupdate_ptrinc of (tmpvar, hisexp(*elt*))
//
| INSmove_ref of (tmpvar, primval) // tmp := ref (pmv)
//
*)
| INSfuncall
    (tmp, _fun, hse, _arg) => let
    val tmp = ftmp (tmp)
    val _fun = fpmv (_fun)
    val hse = hisexp_subst (sub, hse)
    val _arg = fpmvlst (_arg)
  in
    instr_funcall (loc0, tmp, _fun, hse, _arg)
  end // end of [INSfuncall]
(*
| INScond of ( // conditinal instruction
    primval(*test*), instrlst(*then*), instrlst(*else*)
  ) // end of [INScond]
//
| INSpatck of (primval, patck, patckont) // pattern check
//
| INSselect of (tmpvar, primval, hisexp(*rec*), hilablst)
| INSselcon of (tmpvar, primval, hisexp(*sum*), int(*narg*))
//
| INSassgn_varofs of
    (d2var(*left*), primlablst(*ofs*), primval(*right*))
| INSassgn_ptrofs of
    (primval(*left*), primlablst(*ofs*), primval(*right*))
//
| INSletpop of ()
| INSletpush of (primdeclst)
//
*)
| _ => ins0
//
end // end of [instr_subst]

(* ****** ****** *)

implement
instrlst_subst
  (env, map, sub, inss, sfx) = let
//
fun loop (
  env: !ccompenv
, map: !tmpmap
, sub: !stasub
, inss: instrlst
, sfx: int
, res: &instrlst? >> instrlst
) : void = let
in
//
case+ inss of
| list_cons
    (ins, inss) => let
    val ins =
      instr_subst (env, map, sub, ins, sfx)
    // end of [val]
    val () = res := list_cons {instr}{0} (ins, ?)
    val list_cons (_, !p_res1) = res
    val () = loop (env, map, sub, inss, sfx, !p_res1)
    prval () = fold@ (res)
  in
    // nothing
  end // end of [list_cons]
| list_nil () => (res := list_nil ())
//
end // end of [loop]
//
var res: instrlst?
val () = loop (env, map, sub, inss, sfx, res)
//
in
  res
end // end of [instrlst_subst]

(* ****** ****** *)

(* end of [pats_ccomp_subst.dats] *)