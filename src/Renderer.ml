type t = {
  gl: GL.gl;
  shaders: GL.shader * GL.shader;
  program: GL.program
}

let vertex_source = {| 
attribute vec3 a_position;
attribute vec3 a_normal;

uniform mat4 u_norm;
uniform mat4 u_model;
uniform mat4 u_view;
uniform mat4 u_proj;

varying vec3 n;
varying vec3 v;

void main() {
  gl_Position = u_proj * u_view * u_model * vec4(a_position, 1);
  n = normalize((u_norm * vec4(a_normal, 0)).xyz);
  v = (u_view * u_model * vec4(a_position, 1)).xyz;
}
|}

let fragment_source = {| 
precision mediump float;

varying vec3 n;
varying vec3 v;

uniform vec3 light_pos;
uniform vec3 light_amb;
uniform vec3 light_dif;
uniform vec3 light_spec;

uniform vec3 k_amb;
uniform vec3 k_dif;
uniform vec3 k_spec;
uniform float k_shine;

void main() {
  vec3 L = normalize(light_pos - v);
  vec3 N = normalize(n);
  vec3 V = normalize(-v);
  vec3 R = normalize(-reflect(L,N));

  vec3 Ia = k_amb * light_amb;
  vec3 Id = clamp(k_dif * light_dif * max(dot(N, L), 0.0), 0.0, 1.0); 
  vec3 Is = clamp(
    k_spec * light_spec * pow(max(dot(R, V), 0.0), k_shine),
    0.0, 1.0
  );

  gl_FragColor = vec4(Ia + Id + Is, 1);
}
|}

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
  let vertex_shader = compile_shader GL.Constant.vertex_shader vertex_source in
  let fragment_shader = compile_shader GL.Constant.fragment_shader fragment_source in
  let program = GL.create_program gl in
  GL.attach_shader gl program vertex_shader;
  GL.attach_shader gl program fragment_shader;
  GL.bind_attrib_location gl program 0 "a_position";
  GL.bind_attrib_location gl program 1 "a_normal";
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

let use model_mat view_mat proj_mat =
  let { gl; program } = get_renderer () in
  let normal_mat = Matrix.multiply view_mat model_mat |> Matrix.inverse |> Matrix.transpose in
  GL.use_program gl program;
  bind_uniform_mat4 "u_norm" normal_mat;
  bind_uniform_mat4 "u_model" model_mat;
  bind_uniform_mat4 "u_view" view_mat;
  bind_uniform_mat4 "u_proj" proj_mat;
  bind_uniform_3f "k_amb" (0.2, 0.05, 0.1);
  bind_uniform_3f "k_dif" (0.8, 0.2, 0.4);
  bind_uniform_3f "k_spec" (0.8, 0.8, 0.8);
  bind_uniform_f "k_shine" 15.;
  bind_uniform_3f "light_pos" (5000., 5000., 10000.);
  bind_uniform_3f "light_amb" (1., 1., 1.);
  bind_uniform_3f "light_dif" (1., 1., 1.);
  bind_uniform_3f "light_spec" (1., 1., 1.)

let stop () = ()

let draw model model_mat view_mat proj_mat =
  let { gl; } = get_renderer () in
  use model_mat view_mat proj_mat;
  Model.draw gl model;
  stop ();
