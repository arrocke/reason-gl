type t = {
  program: GL.program;
  vertex_shader: Shader.t;
  fragment_shader: Shader.t;
  linked: bool;
  deleted: bool;
}

exception Invalid_program of string

let create vertex_shader fragment_shader =
  let vertex_shader = Shader.compile vertex_shader in
  let fragment_shader = Shader.compile fragment_shader in
  let program = GL.create_program () in
  let () = GL.attach_shader program vertex_shader.shader in
  let () = GL.attach_shader program fragment_shader.shader in
  {
    program;
    vertex_shader;
    fragment_shader;
    linked = false;
    deleted = false;
  }

let bind_attrib p name loc =
  GL.bind_attrib_location p.program loc name

let link p = match p.linked with
| true -> p
| false -> 
  let () = GL.link_program p.program in
  match GL.get_program_parameter p.program GL.Constant.link_status with
  | true -> { p with linked = true; }
  | false ->
    let () = GL.delete_program p.program in
    raise(Invalid_program (GL.get_program_info_log p.program))

let delete p = match p.deleted with
| true -> p
| false ->
  let () = GL.delete_program p.program in
  { p with deleted = true}

let use p = GL.use_program p.program

let uniform_mat4 p name mat =
  let location = GL.get_uniform_location p.program name in
  GL.uniform_matrix_4fv location false (Matrix4.to_float32array mat)

let uniform_4f p name v =
  let location = GL.get_uniform_location p.program name in
  GL.uniform_4fv location v

let uniform_3f p name v =
  let location = GL.get_uniform_location p.program name in
  GL.uniform_3fv location v

let uniform_2f p name v =
  let location = GL.get_uniform_location p.program name in
  GL.uniform_2fv location v

let uniform_1f p name f =
  let location = GL.get_uniform_location p.program name in
  GL.uniform_f location f
