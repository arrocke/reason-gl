module DataType : sig
  type t

  val byte: t
  val ubyte: t
  val short: t
  val ushort: t
  val int: t
  val uint: t
  val float: t
end

module BufferTarget : sig
  type t

  val array: t
  val element_array: t
end

module BufferUsage : sig
  type t

  val static: t
  val stream: t
  val dynamic: t
end

module ClearBuffer : sig
  type t

  val depth: t
  val stencil: t
  val color: t

  val combine: t list -> t
end

module DrawMode : sig
  type t

  val points: t
  val lines: t
  val line_loop: t
  val line_strip: t
  val triangles: t
  val triangle_strip: t
  val triangle_fan: t
end

module ShaderType : sig
  type t = int

  val fragment: t
  val vertex: t
end