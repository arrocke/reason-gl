type t

external create: GL.t -> Constant.ShaderType.t -> t = "createShader" [@@bs.send]
external source: GL.t -> t -> string -> unit = "shaderSource" [@@bs.send]
external compile: GL.t -> t -> unit = "compileShader" [@@bs.send]
external delete: GL.t -> t -> unit = "deleteShader" [@@bs.send]
external compile_status: GL.t -> t -> (_ [@bs.as 0x8B81]) -> bool = "getShaderParameter" [@@bs.send]
external delete_status: GL.t -> t -> (_ [@bs.as 0x8B80]) -> bool = "getShaderParameter" [@@bs.send]
external log: GL.t -> t -> string = "getShaderInfoLog" [@@bs.send]
