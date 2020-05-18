open Constant

let gl = match GL.init () with
| Some(gl) -> gl
| None -> raise(Not_found)

let () = GL.clear_color gl 0.0 0.0 0.0 1.0
let () = GL.clear gl ClearBuffer.color

let vertex_source = {| 
attribute vec4 aVertexPosition;

// uniform mat4 uModelViewMatrix;
// uniform mat4 uProjectionMatrix;

void main() {
  // gl_Position = uProjectionMatrix * uModelViewMatrix * aVertexPosition;
  gl_Position = aVertexPosition;
}
|}

let fragment_source = {| 
void main() {
  gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
}
|}

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

let program = build_program vertex_source fragment_source

let vertex_position = Attribute.location gl program "aVertexPosition"
(* let proj_matrix = Uniform.location(gl, program, "uProjectionMatrix");
let model_view_matrix = Uniform.location(gl, program, "uModelViewMatrix"); *)

let positionBuffer = Buffer.create gl

let () = Buffer.bind gl BufferTarget.array positionBuffer

let vertices = Js.TypedArray2.Float32Array.make [|
  -1.0; 1.0;
  1.0; 1.0;
  -1.0; -1.0;
  1.0; -1.0
|]

let () = Buffer.data_float32 gl BufferTarget.array vertices BufferUsage.static

let () = Attribute.vertex_pointer gl vertex_position 2 DataType.float false 0 0
let () = Attribute.enable_vertex_array gl vertex_position

let () = Program.use gl program
let () = GL.draw_arrays gl DrawMode.triangles 0 4