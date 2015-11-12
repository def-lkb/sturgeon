open Sexp

type 'a result =
  | Feed  of 'a
  | Quit of basic

type 'a neg = 'a result -> unit

val cancel_message : 'a result
val finalize_message : 'a result

type dual =
  | Once of t neg
  | Sink of t neg

and t = dual sexp

val cancel :
  ?stderr:([> `Exceptions_during_cancellation of t * exn list] -> unit) ->
  t -> unit

type 'a error =
  [ `Already_closed  of t result
  | `Query_after_eof of t
  | `Invalid_command of basic
  | `Feed_unknown    of basic
  | `Quit_unknown    of basic
  | `Exceptions_during_cancellation of t * exn list
  | `Exceptions_during_shutdown of exn list
  ]

type endpoint = { stdout : basic -> unit; query : t -> unit; } and status

val connect :
  ?stderr:(_ error -> unit) ->
  (remote_query:(t -> unit) -> endpoint) ->
  endpoint * status

val close : endpoint -> unit
val

val pending_sessions : status -> int
val is_closed : status -> bool
