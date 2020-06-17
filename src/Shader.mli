type t = {
  shader_type: GL.Constant.t;
  shader: GL.shader;
  compiled: bool;
  deleted: bool;
}

exception Invalid_shader of string

val create: GL.Constant.t -> string -> t

val compile: t -> t

val delete: t -> t