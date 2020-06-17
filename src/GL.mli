type gl
type shader
type program
type attrib = int
type uniform = int
type buffer

module Constant: sig
  type t = int

  val byte: t
  val ubyte: t
  val short: t
  val ushort: t
  val int: t
  val uint: t
  val float: t

  val array_buffer: t
  val element_array_buffer: t

  val static_draw: t
  val stream_draw: t
  val dynamic_draw: t

  val depth_buffer_bit: t
  val stencil_buffer_bit: t
  val color_buffer_bit: t

  val points: t
  val lines: t
  val line_loop: t
  val line_strip: t
  val triangles: t
  val triangle_strip: t
  val triangle_fan: t

  val fragment_shader: t
  val vertex_shader: t

  val link_status: t
  val compile_status: t
  
  val cull_face: t
  val depth_test: t
end


val gl: gl
val canvas: Canvas.t
val clear_color: Color.t -> unit
val clear: Constant.t -> unit
val viewport: float -> float -> float -> float -> unit
val enable: Constant.t -> unit

val draw_arrays: Constant.t -> int -> int -> unit
val draw_elements: Constant.t -> int -> Constant.t -> int -> unit

val create_shader: Constant.t -> shader
val shader_source: shader -> string -> unit
val compile_shader: shader -> unit
val delete_shader: shader -> unit
val get_shader_parameter: shader -> Constant.t -> bool
val get_shader_info_log: shader -> string

val create_program: unit -> program
val attach_shader: program -> shader -> unit
val link_program: program -> unit
val get_program_parameter: program -> Constant.t -> bool
val delete_program: program -> unit
val use_program: program -> unit
val get_program_info_log: program -> string

val get_attrib_location: program -> string -> attrib
val bind_attrib_location: program -> int -> string -> unit
val vertex_attrib_pointer: attrib -> int -> Constant.t -> bool -> int -> int -> unit
val enable_vertex_attrib_array: attrib -> unit
val disable_vertex_attrib_array: attrib -> unit
val vertex_attrib_3f: attrib -> float -> float -> float -> unit

val get_uniform_location: program -> string -> uniform
val uniform_matrix_4fv: uniform -> bool -> Js.TypedArray2.Float32Array.t -> unit
val uniform_4fv: uniform -> (float * float * float * float) -> unit
val uniform_3fv: uniform -> (float * float * float) -> unit
val uniform_2fv: uniform -> (float * float) -> unit
val uniform_f: uniform -> float -> unit

val create_buffer: unit -> buffer
val bind_buffer: Constant.t -> buffer -> unit
val buffer_data: Constant.t -> Js.TypedArray2.array_buffer -> Constant.t -> unit
val buffer_data_size: Constant.t -> int -> Constant.t -> unit
val buffer_sub_data: Constant.t -> int -> Js.TypedArray2.array_buffer -> unit

