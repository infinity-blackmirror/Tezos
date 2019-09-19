(** Wrapper around the [tezos-admin-client] application. *)
open Internal_pervasives

(** [t] is very similar to {!Tezos_client.t}. *)
type t = private {id : string; port : int; exec : Tezos_executable.t}

val of_client : exec:Tezos_executable.t -> Tezos_client.t -> t

val of_node : exec:Tezos_executable.t -> Tezos_node.t -> t

(** Build a [Genspio.EDSL.t] command. *)
val make_command :
  t -> < paths : Paths.t ; .. > -> string list -> unit Genspio.EDSL.t

module Command_error : sig
  type t = [`Admin_command_error of string * string list option]

  val failf :
    ?args:string list ->
    ('a, unit, string, ('b, [> t]) Asynchronous_result.t) format4 ->
    'a

  val pp : Format.formatter -> t -> unit
end

val successful_command :
  t ->
  < application_name : string
  ; console : Console.t
  ; paths : Paths.t
  ; runner : Running_processes.State.t
  ; .. > ->
  string list ->
  ( Process_result.t,
    [> Command_error.t | `Lwt_exn of exn] )
  Asynchronous_result.t

val inject_protocol :
  t ->
  < application_name : string
  ; console : Console.t
  ; paths : Paths.t
  ; runner : Running_processes.State.t
  ; .. > ->
  path:string ->
  ( Process_result.t * string,
    [> Command_error.t | `Lwt_exn of exn] )
  Asynchronous_result.t
