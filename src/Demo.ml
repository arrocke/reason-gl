open Constant

type frame_id

external request_frame : (float -> unit) -> frame_id = "requestAnimationFrame" [@@bs.val]

let gl = match GL.init () with
| Some(gl) -> gl
| None -> raise(Not_found)

let canvas = GL.canvas(gl)

exception InvalidShader
exception InvalidProgram

let build_program vertex_source fragment_source =
  let build_shader shader_type source = 
    let shader = Shader.create gl shader_type in
    let () = Shader.source gl shader source in
    let () = Shader.compile gl shader in
    if Shader.compile_status gl shader then
      shader
    else 
      let () = Shader.delete gl shader in
      raise InvalidShader in
  let vertex_shader = build_shader ShaderType.vertex vertex_source in
  let fragment_shader = build_shader ShaderType.fragment fragment_source in
  let program = Program.create(gl) in
  let () = Program.attach_shader gl program vertex_shader in
  let () = Program.attach_shader gl program fragment_shader in
  let () = Program.link gl program in
  if Program.link_status gl program then
    program
  else
    let () = Program.delete gl program in
    raise InvalidProgram

let program = build_program Vertex.source Fragment.source

(* Initialize buffers. *)
let positionBuffer = Buffer.create gl
let () = Buffer.bind gl BufferTarget.array positionBuffer
let vertices = Js.TypedArray2.Float32Array.make [|
  0.0; 0.5;
  0.5; 0.5;
  0.5; 0.0;
  0.0; 0.0;
|]
let () = Buffer.data gl BufferTarget.array vertices BufferUsage.static

(* Get attribute and uniform locations. *)
let a_position = Attribute.location gl program "a_position"
let u_matrix = Uniform.location gl program "u_matrix"

(* Connect buffer to position attribute. *)
let () = Attribute.vertex_pointer gl a_position 2 DataType.float false 0 0
let () = Attribute.enable_vertex_array gl a_position

let scale len n = (mod_float n len) /. len

let rec loop t =
  Js.log2 "Time: " t;
  (* Reset canvas. *)
  GL.clear_color gl 0.0 0.0 0.0 1.0;
  GL.clear gl ClearBuffer.color;
  GL.viewport gl 0.0 0.0 (Canvas.width canvas) (Canvas.height canvas);

  (* Load program and initialize uniforms. *)
  Program.use gl program;
  let mat = Matrix.translation ((2.0 *. (scale 4000.0 t)) -. 1.0) 0.0 0.0 in
  Uniform.matrix4fv gl u_matrix mat;

  (* Use position buffer to draw. *)
  Buffer.bind gl BufferTarget.array positionBuffer;
  GL.draw_arrays gl DrawMode.triangles 0 4;

  (* Request next frame *)
  let _ = request_frame loop in

  ()

let id = request_frame loop