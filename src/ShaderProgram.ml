module type Source = sig
  val vertex_source: string
  val fragment_source: string
  val configure_attribs: (int -> string -> unit) -> unit
end

module Make = functor(Source: Source) -> struct
  type t = {
    gl: GL.gl;
    shaders: GL.shader * GL.shader;
    program: GL.program
  }

  let renderer: t option ref = ref None

  let get_renderer () = match !renderer with
  | Some(renderer) -> renderer
  | None -> raise Not_found

  exception InvalidProgram of (string * string * string)

  let init gl = 
    let compile_shader shader_type source =
      let shader = GL.create_shader gl shader_type in
      let () = GL.shader_source gl shader source in
      let () = GL.compile_shader gl shader in
      shader in
    let vertex_shader = compile_shader GL.Constant.vertex_shader Source.vertex_source in
    let fragment_shader = compile_shader GL.Constant.fragment_shader Source.fragment_source in
    let program = GL.create_program gl in
    GL.attach_shader gl program vertex_shader;
    GL.attach_shader gl program fragment_shader;
    Source.configure_attribs (GL.bind_attrib_location gl program);
    GL.link_program gl program;
    renderer := match GL.get_program_parameter gl program GL.Constant.link_status with
    | true -> Some {
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

  let use () =
    let { gl; program } = get_renderer () in
    GL.use_program gl program

  let stop () = ()

  let bind_uniform_mat4 name mat =
    let { gl; program } = get_renderer () in
    let location = GL.get_uniform_location gl program name in
    GL.uniform_matrix_4fv gl location false (Matrix.to_float32array mat)

  let bind_uniform_4f name v =
    let { gl; program } = get_renderer () in
    let location = GL.get_uniform_location gl program name in
    GL.uniform_4fv gl location v

  let bind_uniform_3f name v =
    let { gl; program } = get_renderer () in
    let location = GL.get_uniform_location gl program name in
    GL.uniform_3fv gl location v

  let bind_uniform_f name f =
    let { gl; program } = get_renderer () in
    let location = GL.get_uniform_location gl program name in
    GL.uniform_f gl location f
end
