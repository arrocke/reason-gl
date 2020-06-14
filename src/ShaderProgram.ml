type t = {
  gl: GL.gl;
  shaders: GL.shader * GL.shader;
  program: GL.program
}

type attrib_dict = (int * string) list

exception InvalidProgram of (string * string * string)

let init gl vertex_source fragment_source attribs = 
  let compile_shader shader_type source =
    let shader = GL.create_shader gl shader_type in
    let () = GL.shader_source gl shader source in
    let () = GL.compile_shader gl shader in
    shader in
  let vertex_shader = compile_shader GL.Constant.vertex_shader vertex_source in
  let fragment_shader = compile_shader GL.Constant.fragment_shader fragment_source in
  let program = GL.create_program gl in
  GL.attach_shader gl program vertex_shader;
  GL.attach_shader gl program fragment_shader;
  List.iter (fun (pos, name) -> GL.bind_attrib_location gl program pos name) attribs;
  GL.link_program gl program;
  match GL.get_program_parameter gl program GL.Constant.link_status with
  | true -> {
      gl;
      program;
      shaders = vertex_shader, fragment_shader;
    }
  | false ->
    let program_log = GL.get_program_info_log gl program in
    let vertex_log = GL.get_shader_info_log gl vertex_shader in
    let fragment_log = GL.get_shader_info_log gl fragment_shader in
    GL.delete_program gl program;
    GL.delete_shader gl vertex_shader;
    GL.delete_shader gl fragment_shader;
    raise (InvalidProgram (program_log, vertex_log, fragment_log))

let use { gl; program; } =
  GL.use_program gl program

let stop { gl; program; } = ()

let bind_uniform_mat4 { gl; program; } name mat =
  let location = GL.get_uniform_location gl program name in
  GL.uniform_matrix_4fv gl location false (Matrix4.to_float32array mat)

let bind_uniform_4f { gl; program; } name v =
  let location = GL.get_uniform_location gl program name in
  GL.uniform_4fv gl location v

let bind_uniform_3f { gl; program; } name v =
  let location = GL.get_uniform_location gl program name in
  GL.uniform_3fv gl location v

let bind_uniform_f {gl; program } name f =
  let location = GL.get_uniform_location gl program name in
  GL.uniform_f gl location f
