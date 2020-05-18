type t

external create: GL.t -> t = "createBuffer" [@@bs.send]
external bind: GL.t -> Constant.BufferTarget.t -> t -> unit = "bindBuffer" [@@bs.send]
external data_float32: GL.t -> Constant.BufferTarget.t -> Js.TypedArray2.Float32Array.t -> Constant.BufferUsage.t -> unit = "bufferData" [@@bs.send]
