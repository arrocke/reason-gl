type t = {
  program: GL.program;
  vertex_shader: Shader.t;
  fragment_shader: Shader.t;
  linked: bool;
  deleted: bool;
}

exception Invalid_program of string

val create: Shader.t -> Shader.t -> t

val bind_attrib: t -> string -> GL.attrib -> unit

val link: t -> t

val delete: t -> t

val use: t -> unit

val uniform_mat4: t -> string -> Matrix4.t -> unit

val uniform_4f: t -> string -> (float * float * float * float) -> unit
val uniform_3f: t -> string -> (float * float * float) -> unit
val uniform_2f: t -> string -> (float * float) -> unit
val uniform_1f: t -> string -> float -> unit
