(**************************************************************************)
(*                                                                        *)
(*    Copyright (c) 2014 - 2017.                                          *)
(*    Dynamic Ledger Solutions, Inc. <contact@tezos.com>                  *)
(*                                                                        *)
(*    All rights reserved. No warranty, explicit or implicit, provided.   *)
(*                                                                        *)
(**************************************************************************)

(** {1 Entity Accessor Signatures} ****************************************)

(** The generic signature of a single data accessor (a single value
    bound to a specific key in the hierarchical (key x value)
    database). *)
module type Single_data_storage = sig

  type t
  type context = t

  (** The type of the value *)
  type value

  (** Tells if the data is already defined *)
  val mem: context -> bool Lwt.t

  (** Retrieve the value from the storage bucket ; returns a
      {!Storage_error} if the key is not set or if the deserialisation
      fails *)
  val get: context -> value tzresult Lwt.t

  (** Retrieves the value from the storage bucket ; returns [None] if
      the data is not initialized, or {!Storage_helpers.Storage_error}
      if the deserialisation fails *)
  val get_option: context -> value option tzresult Lwt.t

  (** Allocates the storage bucket and initializes it ; returns a
      {!Storage_error Missing_key} if the bucket exists *)
  val init: context -> value -> Raw_context.t tzresult Lwt.t

  (** Updates the content of the bucket ; returns a {!Storage_Error
      Existing_key} if the value does not exists *)
  val set: context -> value -> Raw_context.t tzresult Lwt.t

  (** Allocates the data and initializes it with a value ; just
      updates it if the bucket exists *)
  val init_set: context -> value -> Raw_context.t Lwt.t

  (** When the value is [Some v], allocates the data and initializes
      it with [v] ; just updates it if the bucket exists. When the
      valus is [None], delete the storage bucket when the value ; does
      nothing if the bucket does not exists. *)
  val set_option: context -> value option -> Raw_context.t Lwt.t

  (** Delete the storage bucket ; returns a {!Storage_error
      Missing_key} if the bucket does not exists *)
  val delete: context -> Raw_context.t tzresult Lwt.t

  (** Removes the storage bucket and its contents ; does nothing if
      the bucket does not exists *)
  val remove: context -> Raw_context.t Lwt.t

end

(** The generic signature of indexed data accessors (a set of values
    of the same type indexed by keys of the same form in the
    hierarchical (key x value) database). *)
module type Indexed_data_storage = sig

  type t
  type context = t

  (** An abstract type for keys *)
  type key

  (** The type of values *)
  type value

  (** Tells if a given key is already bound to a storage bucket *)
  val mem: context -> key -> bool Lwt.t

  (** Retrieve a value from the storage bucket at a given key ;
      returns {!Storage_error Missing_key} if the key is not set ;
      returns {!Storage_error Corrupted_data} if the deserialisation
      fails. *)
  val get: context -> key -> value tzresult Lwt.t

  (** Retrieve a value from the storage bucket at a given key ;
      returns [None] if the value is not set ; returns {!Storage_error
      Corrupted_data} if the deserialisation fails. *)
  val get_option: context -> key -> value option tzresult Lwt.t

  (** Updates the content of a bucket ; returns A {!Storage_Error
      Missing_key} if the value does not exists. *)
  val set: context -> key -> value -> Raw_context.t tzresult Lwt.t

  (** Allocates a storage bucket at the given key and initializes it ;
      returns a {!Storage_error Existing_key} if the bucket exists. *)
  val init: context -> key -> value -> Raw_context.t tzresult Lwt.t

  (** Allocates a storage bucket at the given key and initializes it
      with a value ; just updates it if the bucket exists. *)
  val init_set: context -> key -> value -> Raw_context.t Lwt.t

  (** When the value is [Some v], allocates the data and initializes
      it with [v] ; just updates it if the bucket exists. When the
      valus is [None], delete the storage bucket when the value ; does
      nothing if the bucket does not exists. *)
  val set_option: context -> key -> value option -> Raw_context.t Lwt.t

  (** Delete a storage bucket and its contents ; returns a
      {!Storage_error Missing_key} if the bucket does not exists. *)
  val delete: context -> key -> Raw_context.t tzresult Lwt.t

  (** Removes a storage bucket and its contents ; does nothing if the
      bucket does not exists. *)
  val remove: context -> key -> Raw_context.t Lwt.t

  val clear: context -> Raw_context.t Lwt.t

  val keys: context -> key list Lwt.t
  val bindings: context -> (key * value) list Lwt.t

  val fold:
    context -> init:'a -> f:(key -> value -> 'a -> 'a Lwt.t) -> 'a Lwt.t
  val fold_keys:
    context -> init:'a -> f:(key -> 'a -> 'a Lwt.t) -> 'a Lwt.t

end

(** The generic signature of a data set accessor (a set of values
    bound to a specific key prefix in the hierarchical (key x value)
    database). *)
module type Data_set_storage = sig

  type t
  type context = t

  (** The type of elements. *)
  type elt

  (** Tells if a elt is a member of the set *)
  val mem: context -> elt -> bool Lwt.t

  (** Adds a elt is a member of the set *)
  val add: context -> elt -> Raw_context.t Lwt.t

  (** Removes a elt of the set ; does nothing if not a member *)
  val del: context -> elt -> Raw_context.t Lwt.t

  (** Returns the elements of the set, deserialized in a list in no
      particular order. *)
  val elements: context -> elt list Lwt.t

  val fold: context -> init:'a -> f:(elt -> 'a -> 'a Lwt.t) -> 'a Lwt.t

  (** Removes all elements in the set *)
  val clear: context -> Raw_context.t Lwt.t

end

module type NAME = sig
  val name: Raw_context.key
end

module type VALUE = sig
  type t
  val of_bytes: MBytes.t -> t tzresult
  val to_bytes: t -> MBytes.t
end

module type Indexed_raw_context = sig

  type t
  type context = t
  type key

  val clear: context -> key -> Raw_context.t Lwt.t

  val fold_keys:
    context -> init:'a -> f:(key -> 'a -> 'a Lwt.t) -> 'a Lwt.t
  val keys: context -> key list Lwt.t

  val resolve: context -> string list -> key list Lwt.t

  module Make_set (N : NAME)
    : Data_set_storage with type t = t
                        and type elt = key

  module Make_map (N : NAME) (V : VALUE)
    : Indexed_data_storage with type t = t
                            and type key = key
                            and type value = V.t

  module Raw_context : Raw_context.T with type t = t * key

end
