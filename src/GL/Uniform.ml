type t

external location: GL.t -> Program.t -> string -> t = "getUniformLocation" [@@bs.send]

external _matrix4fv: GL.t -> t -> (_ [@bs.as {json|false|json}]) -> Js.TypedArray2.Float32Array.t -> unit = "uniformMatrix4fv" [@@bs.send]
let matrix4fv gl loc value = _matrix4fv gl loc (Matrix.to_float32array value)