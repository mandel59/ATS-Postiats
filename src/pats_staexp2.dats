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
// Start Time: May, 2011
//
(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/list.dats"

(* ****** ****** *)

staload LEX = "pats_lexing.sats"

(* ****** ****** *)

staload "pats_basics.sats"

(* ****** ****** *)

staload STAMP = "pats_stamp.sats"
macdef eq_stamp_stamp = $STAMP.eq_stamp_stamp

(* ****** ****** *)

staload "pats_staexp2.sats"

(* ****** ****** *)

#define l2l list_of_list_vt

(* ****** ****** *)

implement
tyreckind_is_box (knd) =
  case+ knd of TYRECKINDbox () => true | _ => false
// end of [tyreckind_is_box]

implement
eq_tyreckind_tyreckind
  (knd1, knd2) = case+ (knd1, knd2) of
  | (TYRECKINDbox (), TYRECKINDbox ()) => true
  | (TYRECKINDflt0 (), TYRECKINDflt0 ()) => true
  | (TYRECKINDflt1 s1, TYRECKINDflt1 s2) => eq_stamp_stamp (s1, s2)
  | (TYRECKINDflt_ext name1, TYRECKINDflt_ext name2) => name1 = name2
  | (_, _) => false
// end of [neq_tyreckind_tyreckind]

implement
neq_tyreckind_tyreckind
  (knd1, knd2) = ~eq_tyreckind_tyreckind (knd1, knd2)
// end of [neq_tyreckind_tyreckind]

(* ****** ****** *)

implement
sp2at_con
  (loc, s2c, s2vs) = let
  val s2fs =
    l2l (list_map_fun (s2vs, s2exp_var))
  val s2e_pat = s2exp_cstapp (s2c, s2fs)
in '{
  sp2at_loc= loc
, sp2at_exp= s2e_pat, sp2at_node = SP2Tcon (s2c, s2vs)
} end // end of [sp2at_con]

implement
sp2at_err (loc) = let
  val s2t_pat = s2rt_err ()
  val s2e_pat = s2exp_err (s2t_pat)
in '{
  sp2at_loc= loc
, sp2at_exp= s2e_pat
, sp2at_node= SP2Terr ()
} end // end of [sp2at_err]

(* ****** ****** *)

implement
s2qua_make
  (svs, sps) = @{
  s2qua_svs= svs, s2qua_sps= sps
} // end of [s2qua_make]

(* ****** ****** *)

extern
castfn s2exp_of_s2exp (x: s2exp): s2exp
macdef hnf = s2exp_of_s2exp // HX: it for commenting

(* ****** ****** *)

implement
s2exp_int (i) = hnf '{
  s2exp_srt= s2rt_int, s2exp_node= S2Eint (i)
} // end of [s2exp_int]
implement
s2exp_intinf (i) = hnf '{
  s2exp_srt= s2rt_int, s2exp_node= S2Eintinf (i)
} // end of [s2exp_intinf]

implement
s2exp_char (c) = hnf '{
  s2exp_srt= s2rt_char, s2exp_node= S2Echar (c)
} // end of [s2exp_char]

implement
s2exp_cst (s2c) = let
  val s2t = s2cst_get_srt (s2c)
in hnf '{
  s2exp_srt= s2t, s2exp_node= S2Ecst (s2c)
} end // end of [s2exp_cst]

implement
s2exp_var (s2v) = let
  val s2t = s2var_get_srt (s2v)
in hnf '{
  s2exp_srt= s2t, s2exp_node= S2Evar (s2v)
} end // end of [s2exp_var]

implement
s2exp_Var (s2V) = let
  val s2t = s2Var_get_srt (s2V)
in '{ // HX: this is not hnf!
  s2exp_srt= s2t, s2exp_node= S2EVar (s2V)
} end // end of [s2exp_Var]

(* ****** ****** *)

implement
s2exp_extype_srt
  (s2t, name, s2ess) = hnf '{
  s2exp_srt= s2t, s2exp_node= S2Eextype (name, s2ess)
} // end of [s2exp_extype_srt]

(* ****** ****** *)

implement
s2exp_at (s2e1, s2e2) = hnf '{
  s2exp_srt= s2rt_view, s2exp_node= S2Eat (s2e1, s2e2)
} // end of [s2exp_at]

implement
s2exp_sizeof (s2e) = hnf '{
  s2exp_srt= s2rt_int, s2exp_node= S2Esizeof (s2e)
} // end of [s2exp_sizeof]

(* ****** ****** *)

implement
s2exp_eqeq (s2e1, s2e2) = hnf '{
  s2exp_srt= s2rt_bool, s2exp_node= S2Eeqeq (s2e1, s2e2)
} // end of [s2exp_eqeq]

(* ****** ****** *)

implement
s2exp_app_srt
  (s2t, _fun, _arg) = '{
  s2exp_srt= s2t, s2exp_node= S2Eapp (_fun, _arg)
} // end of [s2exp_app_srt]

implement
s2exp_lam
  (s2vs, s2e_body) = let
  val s2ts = l2l (list_map_fun (s2vs, s2var_get_srt))
  val s2t_fun = s2rt_fun (s2ts, s2e_body.s2exp_srt)
in
  s2exp_lam_srt (s2t_fun, s2vs, s2e_body)
end // end of [s2exp_lam]

implement
s2exp_lam_srt
  (s2t_fun, s2vs_arg, s2e_body) = '{
  s2exp_srt= s2t_fun, s2exp_node= S2Elam (s2vs_arg, s2e_body)
} // end of [s2exp_lam_srt]

implement
s2exp_lamlst (
  s2vss, s2e_body
) = case+ s2vss of
  | list_cons (s2vs, s2vss) =>
      s2exp_lamlst (s2vss, s2exp_lam (s2vs, s2e_body))
  | list_nil () => s2e_body
// end of [s2exp_lamlst]

implement
s2exp_fun_srt (
  s2t, fc, lin, s2fe, npf, _arg, _res
) = hnf '{
  s2exp_srt= s2t, s2exp_node= S2Efun (fc, lin, s2fe, npf, _arg, _res)
} // end of [s2exp_fun_srt]

implement
s2exp_metfn (
  opt, s2es_met, s2e_body
) = let
  val s2t = s2e_body.s2exp_srt
in hnf '{
  s2exp_srt= s2t, s2exp_node= S2Emetfn (opt, s2es_met, s2e_body)
} end // end of [s2exp_metfn]

(* ****** ****** *)

implement
s2exp_metlt (
  s2es1, s2es2
) = hnf '{
  s2exp_srt= s2rt_bool, s2exp_node= S2Emetlt (s2es1, s2es2)
} // end of [s2exp_metlt]

(* ****** ****** *)

implement
s2exp_cstapp
  (s2c_fun, s2es_arg) = let
  val s2t_fun = s2cst_get_srt s2c_fun
  val s2e_fun = s2exp_cst (s2c_fun)
  val- S2RTfun (s2ts_arg, s2t_res) = s2t_fun
in
  hnf (s2exp_app_srt (s2t_res, s2e_fun, s2es_arg))
end // end of [s2exp_cstapp]

implement
s2exp_confun (
  npf, s2es_arg, s2e_res
) = hnf '{
  s2exp_srt= s2rt_type
, s2exp_node= S2Efun (
    FUNCLOfun (), 0(*lin*), S2EFFnil (), npf, s2es_arg, s2e_res
  ) // end of [S2Efun]
} (* end of [s2exp_confun] *)

(* ****** ****** *)

implement
s2exp_datconptr
  (d2c, arg) = let
  val arity_real = d2con_get_arity_real (d2c)
  val s2t = (
    if arity_real > 0 then s2rt_viewtype else s2rt_type
  ) : s2rt // end of [val]
in hnf '{
  s2exp_srt= s2t, s2exp_node= S2Edatconptr (d2c, arg)
} end // end of [s2exp_datconptr]

implement
s2exp_datcontyp
  (d2c, arg) = let
  val arity_real = d2con_get_arity_real (d2c)
  val s2t = (
    if arity_real > 0 then s2rt_viewtype else s2rt_type
  ) : s2rt // end of [val]
in hnf '{
  s2exp_srt= s2t, s2exp_node= S2Edatcontyp (d2c, arg)
} end // end of [s2exp_datcontyp]

(* ****** ****** *)

implement
s2exp_top_srt (s2t, knd, s2e) = '{
  s2exp_srt= s2t, s2exp_node= S2Etop (knd, s2e)
} // end of [s2exp_top_srt]

(* ****** ****** *)

implement
s2exp_tyarr (elt, ind) = hnf '{
  s2exp_srt=elt.s2exp_srt, s2exp_node= S2Etyarr (elt, ind)
}

implement
s2exp_tyrec_srt
  (s2t, knd, npf, ls2es) = hnf '{
  s2exp_srt= s2t, s2exp_node= S2Etyrec (knd, npf, ls2es)
}

(* ****** ****** *)

implement
s2exp_invar (s2e) = hnf '{
  s2exp_srt= s2e.s2exp_srt, s2exp_node= S2Einvar (s2e)
} // end of [s2exp_invar]

(* ****** ****** *)

implement
s2exp_refarg (refval, s2e) = '{
  s2exp_srt= s2e.s2exp_srt, s2exp_node= S2Erefarg (refval, s2e)
} // end of [s2exp_refarg]

implement
s2exp_vararg (s2e) = hnf '{
  s2exp_srt= s2rt_t0ype, s2exp_node= S2Evararg (s2e)
} // end of [s2exp_vararg]

(* ****** ****** *)

implement
s2exp_exi (
  s2vs, s2ps, s2f
) = case+ (s2vs, s2ps) of
  | (list_nil (), list_nil ()) => s2f
  | (_, _) => hnf '{
      s2exp_srt= s2f.s2exp_srt, s2exp_node= S2Eexi (s2vs, s2ps, s2f)
    } // end of [s2exp_exi]
// end of [s2exp_exi]

implement
s2exp_uni (
  s2vs, s2ps, s2f
) = case+ (s2vs, s2ps) of
  | (list_nil (), list_nil ()) => s2f
  | (_, _) => hnf '{
      s2exp_srt= s2f.s2exp_srt, s2exp_node= S2Euni (s2vs, s2ps, s2f)
    } // end of [s2exp_uni]
// end of [s2exp_uni]

implement
s2exp_exiuni
  (knd, s2vs, s2ps, s2e) =
  if knd = 0 then
    s2exp_exi (s2vs, s2ps, s2e)
  else
    s2exp_uni (s2vs, s2ps, s2e)
  (* end of [if] *)
// end of [s2exp_exiuni]

implement
uns2exp_exiuni (
  knd, s2f, s2vs, s2ps, scope
) =
  case+ s2f.s2exp_node of
  | S2Eexi (s2vs1, s2ps1, s2e1) when knd = 0 =>
      (s2vs := s2vs1; s2ps := s2ps1; scope := s2e1; true)
  | S2Euni (s2vs1, s2ps1, s2e1) when knd = 1 =>
      (s2vs := s2vs1; s2ps := s2ps1; scope := s2e1; true)
  | _ => let
      val () = s2vs := list_nil
      and () = s2ps := list_nil
      val () = scope := s2f // dummy value
    in
      false
    end // end of [_]
// end of [uns2exp_exiuni]

(* ****** ****** *)

implement
s2exp_unis (s2qs, s2f) =
  case+ s2qs of
  | list_nil () => s2f
  | list_cons (s2q, s2qs) => (
      s2exp_uni (s2q.s2qua_svs, s2q.s2qua_sps, s2exp_unis (s2qs, s2f))
    ) // end of [list_cons]
// end of [s2exp_unis]

(* ****** ****** *)

implement
s2exp_wth (s2e, wths2es) = '{
  s2exp_srt= s2e.s2exp_srt, s2exp_node= S2Ewth (s2e, wths2es)
} // end of [s2exp_wth]

(* ****** ****** *)

(*
implement
s2hnf_err (s2t) = hnf (s2exp_err (s2t))
*)

implement
s2exp_err (s2t) = '{
  s2exp_srt= s2t, s2exp_node= S2Eerr ()
}
implement
s2exp_s2rt_err () = s2exp_err (s2rt_err ())

(* ****** ****** *)

implement
s2exp_is_prf
  (s2e) = s2rt_is_prf (s2e.s2exp_srt)
// end of [s2exp_is_prf]

implement
s2exp_is_lin
  (s2e) = s2rt_is_lin (s2e.s2exp_srt)
// end of [s2exp_is_lin]
implement
s2exp_is_nonlin (s2e) = ~s2exp_is_lin (s2e)

implement
s2exp_is_impredicative
  (s2e) = s2rt_is_impredicative (s2e.s2exp_srt)
// end of [s2exp_is_impredicative]

(* ****** ****** *)

implement
s2exparg_one (loc) = '{
  s2exparg_loc= loc, s2exparg_node= S2EXPARGone ()
}
implement
s2exparg_all (loc) = '{
  s2exparg_loc= loc, s2exparg_node= S2EXPARGall ()
}
implement
s2exparg_seq (loc, s2fs) = '{
  s2exparg_loc= loc, s2exparg_node= S2EXPARGseq (s2fs)
}

(* ****** ****** *)

implement
t2mpmarg_make (loc, s2fs) = '{
  t2mpmarg_loc= loc, t2mpmarg_arg= s2fs
} // end of [t2mpmarg_make]

(* ****** ****** *)

implement
s2tavar_make (loc, s2v) = '{
  s2tavar_loc= loc, s2tavar_var= s2v
} // end of [s2tavar_make]

implement
s2aspdec_make (loc, s2c, def) = '{
  s2aspdec_loc= loc, s2aspdec_cst= s2c, s2aspdec_def= def
} // end of [s2aspdec_make]

(* ****** ****** *)

(* end of [pats_staexp2.dats] *)
