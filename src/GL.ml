type gl 
type shader
type program
type attrib = int
type uniform = int
type buffer

let init: unit -> gl option = [%raw {|
  function () {
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

let gl = match init () with 
| Some(gl) -> gl
| None -> raise(Not_found)

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


external canvas: gl -> Canvas.t = "canvas" [@@bs.get]
let canvas = canvas gl

external clear_color: gl -> float -> float -> float -> float -> unit = "clearColor" [@@bs.send]
let clear_color (r, g, b, a) = clear_color gl r g b a

external clear: gl -> Constant.t -> unit = "clear" [@@bs.send]
let clear = clear gl

external viewport: gl -> float -> float -> float -> float -> unit = "viewport" [@@bs.send]
let viewport = viewport gl

external enable: gl -> Constant.t -> unit = "enable" [@@bs.send]
let enable = enable gl


external draw_arrays: gl -> Constant.t -> int -> int -> unit = "drawArrays" [@@bs.send]
let draw_arrays = draw_arrays gl

external draw_elements: gl -> Constant.t -> int -> Constant.t -> int -> unit = "drawElements" [@@bs.send]
let draw_elements = draw_elements gl


external create_shader: gl -> Constant.t -> shader = "createShader" [@@bs.send]
let create_shader = create_shader gl

external shader_source: gl -> shader -> string -> unit = "shaderSource" [@@bs.send]
let shader_source = shader_source gl

external compile_shader: gl -> shader -> unit = "compileShader" [@@bs.send]
let compile_shader = compile_shader gl

external delete_shader: gl -> shader -> unit = "deleteShader" [@@bs.send]
let delete_shader = delete_shader gl

external get_shader_parameter: gl -> shader -> Constant.t -> bool = "getShaderParameter" [@@bs.send]
let get_shader_parameter = get_shader_parameter gl

external get_shader_info_log: gl -> shader -> string = "getShaderInfoLog" [@@bs.send]
let get_shader_info_log = get_shader_info_log gl


external create_program: gl -> program = "createProgram" [@@bs.send]
let create_program = create_program gl

external attach_shader: gl -> program -> shader -> unit = "attachShader" [@@bs.send]
let attach_shader = attach_shader gl

external link_program: gl -> program -> unit = "linkProgram" [@@bs.send]
let link_program = link_program gl

external get_program_parameter: gl -> program -> Constant.t -> bool = "getProgramParameter" [@@bs.send]
let get_program_parameter = get_program_parameter gl

external delete_program: gl -> program -> unit = "deleteProgram" [@@bs.send]
let delete_program = delete_program gl

external use_program: gl -> program -> unit = "useProgram" [@@bs.send]
let use_program = use_program gl

external get_program_info_log: gl -> program -> string = "getProgramInfoLog" [@@bs.send]
let get_program_info_log = get_program_info_log gl


external get_attrib_location: gl -> program -> string -> attrib = "getAttribLocation" [@@bs.send]
let get_attrib_location = get_attrib_location gl

external bind_attrib_location: gl -> program -> int -> string -> unit = "bindAttribLocation" [@@bs.send]
let bind_attrib_location = bind_attrib_location gl

external vertex_attrib_pointer: gl -> attrib -> int -> Constant.t -> bool -> int -> int -> unit = "vertexAttribPointer" [@@bs.send]
let vertex_attrib_pointer = vertex_attrib_pointer gl

external enable_vertex_attrib_array: gl -> attrib -> unit = "enableVertexAttribArray" [@@bs.send]
let enable_vertex_attrib_array = enable_vertex_attrib_array gl

external disable_vertex_attrib_array: gl -> attrib -> unit = "disableVertexAttribArray" [@@bs.send]
let disable_vertex_attrib_array = disable_vertex_attrib_array gl

external vertex_attrib_3f: gl -> attrib -> float -> float -> float -> unit = "vertexAttrib3f" [@@bs.send]
let vertex_attrib_3f = vertex_attrib_3f gl


external get_uniform_location: gl -> program -> string -> uniform = "getUniformLocation" [@@bs.send]
let get_uniform_location = get_uniform_location gl

external uniform_matrix_4fv: gl -> uniform -> bool -> Js.TypedArray2.Float32Array.t -> unit = "uniformMatrix4fv" [@@bs.send]
let uniform_matrix_4fv = uniform_matrix_4fv gl

external uniform_4fv: gl -> uniform -> (float * float * float * float) -> unit = "uniform4fv" [@@bs.send]
let uniform_4fv = uniform_4fv gl

external uniform_3fv: gl -> uniform -> (float * float * float) -> unit = "uniform3fv" [@@bs.send]
let uniform_3fv = uniform_3fv gl

external uniform_f: gl -> uniform -> float -> unit = "uniform1f" [@@bs.send]
let uniform_f = uniform_f gl


external create_buffer: gl -> buffer = "createBuffer" [@@bs.send]
let create_buffer () = create_buffer gl

external bind_buffer: gl -> Constant.t -> buffer -> unit = "bindBuffer" [@@bs.send]
let bind_buffer = bind_buffer gl

external buffer_data: gl -> Constant.t -> Js.TypedArray2.array_buffer -> Constant.t -> unit = "bufferData" [@@bs.send]
let buffer_data = buffer_data gl

external buffer_data_size: gl -> Constant.t -> int -> Constant.t -> unit = "bufferData" [@@bs.send]
let buffer_data_size = buffer_data_size gl

external buffer_sub_data: gl -> Constant.t -> int -> Js.TypedArray2.array_buffer -> unit = "bufferSubData" [@@bs.send]
let buffer_sub_data = buffer_sub_data gl


