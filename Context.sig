(*  Celf
 *  Copyright (C) 2008 Anders Schack-Nielsen and Carsten Sch�rmann
 *
 *  This file is part of Celf.
 *
 *  Celf is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Celf is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Celf.  If not, see <http://www.gnu.org/licenses/>.
 *)

signature CONTEXT =
sig

exception ExnCtx of string

(* NONE means used; we never need to distinguish used affine and used linear *)
datatype modality = INT | AFF | LIN
type cmodality = modality option
type 'a context

val ctx2list : 'a context -> (string * 'a * cmodality) list
val list2ctx : (string * 'a * cmodality) list -> 'a context
val ctxCons : (string * 'a * cmodality) -> 'a context -> 'a context
val ctxMap : ('a -> 'b) -> 'a context -> 'b context

val ctxLength : 'a context -> int

val emptyCtx : 'a context

val ctxIntPart : 'a context -> 'a context
val ctxAffPart : 'a context -> 'a context

val ctxLookupNum : 'a context * int -> 'a context * modality * 'a
val ctxLookupName : 'a context * string -> (int * modality * 'a * 'a context) option

val ctxPush : string * modality * 'a * 'a context -> 'a context
val ctxPushNO : 'a * 'a context -> 'a context
val ctxCondPushINT : string option * 'a * 'a context -> 'a context
val ctxPop : 'a context -> 'a context

val ctxAddJoin : 'a context * 'a context -> 'a context

(* if  AffPart(G1)=G1  then  ctxJoinAffLin (G1, G2) = G1+LinPart(G2) *)
val ctxJoinAffLin : 'a context * 'a context -> 'a context

(* New functions for sparse contexts *)

(* ctx2sparseList returns the list of unused hypotheses.
   For each of these, it returns its deBruijn index, name, and modality.
   The result is ordered by index.
 *)
val ctx2sparseList : 'a context -> (int * string * 'a * modality) list

(* sparseList2ctx is the inverse of ctx2sparseList
   Assumes that the argument is ordered by index
 *)
val sparseList2ctx : (int * string * 'a * modality) list -> 'a context

(* ctxPushList is the list version of ctxPush.
   Elements are pushed left-to-right
 *)
val ctxPushList : (string * modality * 'a) list -> 'a context -> 'a context

(* ctxPopNum n repeats ctxPop n times *)
val ctxPopNum : int -> 'a context -> 'a context

end
