open Constant;

let canvas = GL.query_canvas("#canvas");
let gl = switch(GL.init_GL(canvas)) {
| Some(gl) => gl
| None => raise(Not_found)
};
GL.clear_color(gl, 0.0, 0.0, 0.0, 1.0)
GL.clear(gl, ClearBuffer.color);

let vertex_source = "
attribute vec4 aVertexPosition;

// uniform mat4 uModelViewMatrix;
// uniform mat4 uProjectionMatrix;

void main() {
  // gl_Position = uProjectionMatrix * uModelViewMatrix * aVertexPosition;
  gl_Position = aVertexPosition;
}
"

let fragment_source = "
void main() {
  gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
}
"

exception InvalidShader(string)

let build_shader = (shader_type, source) => {
  let shader = Shader.create(gl, shader_type);
  Shader.source(gl, shader, source);
  Shader.compile(gl, shader);
  if (Shader.compile_status(gl, shader)) {
    shader;
  } else {
    Shader.delete(gl, shader);
    raise(InvalidShader(Shader.log(gl, shader)))
  }
}

exception InvalidProgram(string)

let build_program = (vertex_source, fragment_source) => {
  let vertex_shader = build_shader(ShaderType.vertex, vertex_source)
  let fragment_shader = build_shader(ShaderType.fragment, fragment_source)

  let program = Program.create(gl);
  Program.attach_shader(gl, program, vertex_shader);
  Program.attach_shader(gl, program, fragment_shader);
  Program.link(gl, program);

  if (Program.link_status(gl, program)) {
    program
  } else {
    Program.delete(gl, program);
    raise(InvalidProgram(Program.log(gl, program)))
  }
}

let program = build_program(vertex_source, fragment_source)

let vertex_position = Attribute.location(gl, program, "aVertexPosition");
// let proj_matrix = Uniform.location(gl, program, "uProjectionMatrix");
// let model_view_matrix = Uniform.location(gl, program, "uModelViewMatrix");

let positionBuffer = Buffer.create(gl);
Buffer.bind(gl, BufferTarget.array, positionBuffer);
let vertices = Js.TypedArray2.Float32Array.make([|
  -1.0, 1.0,
  1.0, 1.0,
  -1.0, -1.0,
  1.0, -1.0
|])
Buffer.data_float32(gl, BufferTarget.array, vertices, BufferUsage.static)

Attribute.vertex_pointer(gl, vertex_position, 2, DataType.float, false, 0, 0);
Attribute.enable_vertex_array(gl, vertex_position);

Program.use(gl, program);
GL.draw_arrays(gl, DrawMode.triangles, 0, 4);