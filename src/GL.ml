type gl 
type shader
type program
type attrib = int
type uniform = int
type buffer

let _gl: gl option ref = ref None

exception GL_uninitialized

let gl () = ! _gl

module Constant = struct
  type t = int

  let byte = 0x1400
  let ubyte = 0x1401
  let short = 0x1402
  let ushort = 0x1403
  let int = 0x1404
  let uint = 0x1405
  let float = 0x1406

  let array_buffer = 0x8892
  let element_array_buffer = 0x8893

  let static_draw = 0x88E4
  let stream_draw = 0x88E0
  let dynamic_draw = 0x88E8

  let depth_buffer_bit = 0x00000100
  let stencil_buffer_bit = 0x00000400
  let color_buffer_bit = 0x00004000

  let points = 0x0000
  let lines = 0x0001
  let line_loop = 0x0002
  let line_strip = 0x0003
  let triangles = 0x0004
  let triangle_strip = 0x0005
  let triangle_fan = 0x0006

  let fragment_shader = 0x8B30
  let vertex_shader = 0x8B31

  let link_status = 0x8B82
  let compile_status = 0x8B81 

  let cull_face = 0x0B44
  let depth_test = 0x0B71
end

let init: unit -> gl option = [%raw {|
  function() {
    const canvas = document.createElement('canvas')
    window.addEventListener('resize', () => {
      canvas.width = canvas.clientWidth
      canvas.height = canvas.clientHeight
    })
    document.body.append(canvas)
    canvas.width = canvas.clientWidth
    canvas.height = canvas.clientHeight
    return canvas.getContext('webgl')
  }
|}]

external canvas: gl -> Canvas.t = "canvas" [@@bs.get]

external clear_color: gl -> float -> float -> float -> float -> unit = "clearColor" [@@bs.send]
external clear: gl -> Constant.t -> unit = "clear" [@@bs.send]
external viewport: gl -> float -> float -> float -> float -> unit = "viewport" [@@bs.send]
external draw_arrays: gl -> Constant.t -> int -> int -> unit = "drawArrays" [@@bs.send]
external draw_elements: gl -> Constant.t -> int -> Constant.t -> int -> unit = "drawElements" [@@bs.send]
external enable: gl -> Constant.t -> unit = "enable" [@@bs.send]

external create_shader: gl -> Constant.t -> shader = "createShader" [@@bs.send]
external shader_source: gl -> shader -> string -> unit = "shaderSource" [@@bs.send]
external compile_shader: gl -> shader -> unit = "compileShader" [@@bs.send]
external delete_shader: gl -> shader -> unit = "deleteShader" [@@bs.send]
external get_shader_parameter: gl -> shader -> Constant.t -> bool = "getShaderParameter" [@@bs.send]
external get_shader_info_log: gl -> shader -> string = "getShaderInfoLog" [@@bs.send]

external create_program: gl -> program = "createProgram" [@@bs.send]
external attach_shader: gl -> program -> shader -> unit = "attachShader" [@@bs.send]
external link_program: gl -> program -> unit = "linkProgram" [@@bs.send]
external get_program_parameter: gl -> program -> Constant.t -> bool = "getProgramParameter" [@@bs.send]
external delete_program: gl -> program -> unit = "deleteProgram" [@@bs.send]
external use_program: gl -> program -> unit = "useProgram" [@@bs.send]
external get_program_info_log: gl -> program -> string = "getProgramInfoLog" [@@bs.send]

external get_attrib_location: gl -> program -> string -> attrib = "getAttribLocation" [@@bs.send]
external bind_attrib_location: gl -> program -> int -> string -> unit = "bindAttribLocation" [@@bs.send]
external vertex_attrib_pointer: gl -> attrib -> int -> Constant.t -> bool -> int -> int -> unit = "vertexAttribPointer" [@@bs.send]
external enable_vertex_attrib_array: gl -> attrib -> unit = "enableVertexAttribArray" [@@bs.send]
external disable_vertex_attrib_array: gl -> attrib -> unit = "disableVertexAttribArray" [@@bs.send]
external vertex_attrib_3f: gl -> attrib -> float -> float -> float -> unit = "vertexAttrib3f" [@@bs.send]

external get_uniform_location: gl -> program -> string -> uniform = "getUniformLocation" [@@bs.send]
external uniform_matrix_4fv: gl -> uniform -> bool -> Js.TypedArray2.Float32Array.t -> unit = "uniformMatrix4fv" [@@bs.send]
external uniform_4fv: gl -> uniform -> (float * float * float * float) -> unit = "uniform4fv" [@@bs.send]
external uniform_3fv: gl -> uniform -> (float * float * float) -> unit = "uniform3fv" [@@bs.send]
external uniform_f: gl -> uniform -> float -> unit = "uniform1f" [@@bs.send]

external create_buffer: gl -> buffer = "createBuffer" [@@bs.send]
external bind_buffer: gl -> Constant.t -> buffer -> unit = "bindBuffer" [@@bs.send]
external buffer_data: gl -> Constant.t -> Js.TypedArray2.array_buffer -> Constant.t -> unit = "bufferData" [@@bs.send]
external buffer_data_size: gl -> Constant.t -> int -> Constant.t -> unit = "bufferData" [@@bs.send]
external buffer_sub_data: gl -> Constant.t -> int -> Js.TypedArray2.array_buffer -> unit = "bufferSubData" [@@bs.send]

