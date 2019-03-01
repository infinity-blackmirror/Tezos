(*****************************************************************************)
(*                                                                           *)
(* Open Source License                                                       *)
(* Copyright (c) 2018 Dynamic Ledger Solutions, Inc. <contact@tezos.com>     *)
(*                                                                           *)
(* Permission is hereby granted, free of charge, to any person obtaining a   *)
(* copy of this software and associated documentation files (the "Software"),*)
(* to deal in the Software without restriction, including without limitation *)
(* the rights to use, copy, modify, merge, publish, distribute, sublicense,  *)
(* and/or sell copies of the Software, and to permit persons to whom the     *)
(* Software is furnished to do so, subject to the following conditions:      *)
(*                                                                           *)
(* The above copyright notice and this permission notice shall be included   *)
(* in all copies or substantial portions of the Software.                    *)
(*                                                                           *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR*)
(* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  *)
(* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   *)
(* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER*)
(* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING   *)
(* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER       *)
(* DEALINGS IN THE SOFTWARE.                                                 *)
(*                                                                           *)
(*****************************************************************************)

open Proto_alpha
open Alpha_context

type t

val load:
  #Client_context.wallet ->
  t tzresult Lwt.t

val save:
  #Client_context.wallet ->
  t ->
  unit tzresult Lwt.t

val mem:
  t ->
  Chain_id.t ->
  Block_hash.t ->
  bool

val find_opt:
  t ->
  Chain_id.t ->
  Block_hash.t ->
  Nonce.t option

val add:
  t ->
  Chain_id.t ->
  Block_hash.t ->
  Nonce.t ->
  t

val remove:
  t ->
  Chain_id.t ->
  Block_hash.t ->
  t

val remove_all:
  t ->
  Chain_id.t ->
  t

val find_chain_nonces_opt:
  t ->
  Chain_id.t ->
  Nonce.t Block_hash.Map.t option

val should_upgrade_nonce_file:
  #Client_context.full ->
  bool tzresult Lwt.t

val upgrade_nonce_file:
  #Client_context.full ->
  main_chain_id: Chain_id.t ->
  unit tzresult Lwt.t
