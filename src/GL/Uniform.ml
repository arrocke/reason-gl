type t

external location: GL.t -> Program.t -> string -> t = "getUniformLocation" [@@bs.send]
