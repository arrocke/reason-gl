type t

external create: GL.t -> t = "createProgram" [@@bs.send]
external attach_shader: GL.t -> t -> Shader.t -> unit = "attachShader" [@@bs.send]
external link: GL.t -> t -> unit = "linkProgram" [@@bs.send]
external link_status: GL.t -> t -> (_ [@bs.as 0x8B82]) -> bool = "getProgramParameter" [@@bs.send]
external delete: GL.t -> t -> unit = "deleteProgram" [@@bs.send]
external use: GL.t -> t -> unit = "useProgram" [@@bs.send]
external log: GL.t -> t -> string = "getProgramInfoLog" [@@bs.send]
