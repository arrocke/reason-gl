type t = {
  shaders: GL.shader * GL.shader;
  program: GL.program
}

type attrib_dict = (int * string) list

exception InvalidProgram of (string * string * string)

let init vertex_source fragment_source attribs = 
  let compile_shader shader_type source =
    let shader = GL.create_shader shader_type in
    let () = GL.shader_source shader source in
    let () = GL.compile_shader shader in
    shader in
  let vertex_shader = compile_shader GL.Constant.vertex_shader vertex_source in
  let fragment_shader = compile_shader GL.Constant.fragment_shader fragment_source in
  let program = GL.create_program in
  GL.attach_shader program vertex_shader;
  GL.attach_shader program fragment_shader;
  List.iter (fun (pos, name) -> GL.bind_attrib_location program pos name) attribs;
  GL.link_program program;
  match GL.get_program_parameter program GL.Constant.link_status with
  | true -> {
      program;
      shaders = vertex_shader, fragment_shader;
    }
  | false ->
    let program_log = GL.get_program_info_log program in
    let vertex_log = GL.get_shader_info_log vertex_shader in
    let fragment_log = GL.get_shader_info_log fragment_shader in
    GL.delete_program program;
    GL.delete_shader vertex_shader;
    GL.delete_shader fragment_shader;
    raise (InvalidProgram (program_log, vertex_log, fragment_log))

let use { program; } =
  GL.use_program program

let stop { program; } = ()

let bind_uniform_mat4 { program; } name mat =
  let location = GL.get_uniform_location program name in
  GL.uniform_matrix_4fv location false (Matrix4.to_float32array mat)

let bind_uniform_4f { program; } name v =
  let location = GL.get_uniform_location program name in
  GL.uniform_4fv location v

let bind_uniform_3f { program; } name v =
  let location = GL.get_uniform_location program name in
  GL.uniform_3fv location v

let bind_uniform_f { program } name f =
  let location = GL.get_uniform_location program name in
  GL.uniform_f location f
