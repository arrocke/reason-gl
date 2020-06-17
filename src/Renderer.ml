let vertex_source = {| 
  attribute vec3 a_position;
  attribute vec3 a_normal;
  attribute vec3 a_color;

  uniform mat4 u_norm;
  uniform mat4 u_model;
  uniform mat4 u_view;
  uniform mat4 u_proj;

  varying vec3 n;
  varying vec3 v;
  varying vec3 color;

  void main() {
    gl_Position = u_proj * u_view * u_model * vec4(a_position, 1);
    n = normalize((u_norm * vec4(a_normal, 0)).xyz);
    v = (u_view * u_model * vec4(a_position, 1)).xyz;
    color = a_color;
  }
|}

let fragment_source = {| 
  precision mediump float;

  varying vec3 n;
  varying vec3 v;
  varying vec3 color;

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

    gl_FragColor = vec4(color * (Ia + Id + Is), 1);
  }
|}

let attribs = [
  0, "a_position";
  1, "a_normal";
  2, "a_color";
]

type t = {
  program: ShaderProgram.t;
  light: Light.t;
}

let init gl light = {
  program = ShaderProgram.init vertex_source fragment_source attribs;
  light;
}

let use { program; light } model_mat view_mat proj_mat =
  let normal_mat = Matrix4.multiply view_mat model_mat |> Matrix4.inverse |> Matrix4.transpose in
  let light_pos = Matrix4.multiply_point view_mat (Light.position light) in

  ShaderProgram.use program;

  ShaderProgram.bind_uniform_mat4 program "u_norm" normal_mat;
  ShaderProgram.bind_uniform_mat4 program "u_model" model_mat;
  ShaderProgram.bind_uniform_mat4 program "u_view" view_mat;
  ShaderProgram.bind_uniform_mat4 program "u_proj" proj_mat;

  ShaderProgram.bind_uniform_3f program "k_amb" (0.2, 0.05, 0.1);
  ShaderProgram.bind_uniform_3f program "k_dif" (0.8, 0.2, 0.4);
  ShaderProgram.bind_uniform_3f program "k_spec" (0.8, 0.8, 0.8);
  ShaderProgram.bind_uniform_f program "k_shine" 15.;

  ShaderProgram.bind_uniform_3f
    program
    "light_pos"
    (Point3.uniform_3 light_pos);
  ShaderProgram.bind_uniform_3f
    program
    "light_amb"
    (Color.tuple_3 (Light.ambient light));
  ShaderProgram.bind_uniform_3f
    program
    "light_dif"
    (Color.tuple_3 (Light.diffuse light));
  ShaderProgram.bind_uniform_3f
    program
    "light_spec"
    (Color.tuple_3 (Light.specular light))

let draw r model model_mat view_mat proj_mat =
  use r model_mat view_mat proj_mat;
  Model.draw model;
  ShaderProgram.stop r.program;
