type t = {
  shader_type: GL.Constant.t;
  shader: GL.shader;
  compiled: bool;
  deleted: bool;
}

exception Invalid_shader of string

let create shader_type source =
  let shader = GL.create_shader shader_type in
  let () = GL.shader_source shader source in
  {
    shader_type;
    shader;
    deleted = false;
    compiled = false;
  }

let compile s = match s.compiled with
| true -> s
| false -> 
  let () = GL.compile_shader s.shader in
  match GL.get_shader_parameter s.shader GL.Constant.compile_status with
  | true -> { s with compiled = true; }
  | false ->
    let () = GL.delete_shader s.shader in
    raise(Invalid_shader (GL.get_shader_info_log s.shader))

let delete s = match s.deleted with
| true -> s
| false ->
  let () = GL.delete_shader s.shader in
  { s with deleted = true; }