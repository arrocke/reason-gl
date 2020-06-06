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

let attribs = [
  0, "a_position";
  1, "a_normal";
]

type light = {
  position: Vector3.t;
  ambient: Vector3.t;
  diffuse: Vector3.t;
  specular: Vector3.t;
}

type t = {
  program: ShaderProgram.t;
  light: light
}

let init gl = {
  program = ShaderProgram.init gl vertex_source fragment_source attribs;
  light = {
    position = Vector3.create 0. 0. 0.;
    ambient = Vector3.create 1. 1. 1.;
    diffuse = Vector3.create 1. 1. 1.;
    specular = Vector3.create 1. 1. 1.;
  }
}

let set_light r position ambient diffuse specular =
  {
    r with
    light = {
      position;
      ambient;
      diffuse;
      specular;
    }
  }

let use { program; light } model_mat view_mat proj_mat =
  ShaderProgram.use program;
  let normal_mat = Matrix.multiply view_mat model_mat |> Matrix.inverse |> Matrix.transpose in
  ShaderProgram.bind_uniform_mat4 program "u_norm" normal_mat;
  ShaderProgram.bind_uniform_mat4 program "u_model" model_mat;
  ShaderProgram.bind_uniform_mat4 program "u_view" view_mat;
  ShaderProgram.bind_uniform_mat4 program "u_proj" proj_mat;
  ShaderProgram.bind_uniform_3f program "k_amb" (0.2, 0.05, 0.1);
  ShaderProgram.bind_uniform_3f program "k_dif" (0.8, 0.2, 0.4);
  ShaderProgram.bind_uniform_3f program "k_spec" (0.8, 0.8, 0.8);
  ShaderProgram.bind_uniform_f program "k_shine" 15.;
  ShaderProgram.bind_uniform_3f program "light_pos" (Matrix.multiply_vector view_mat light.position);
  ShaderProgram.bind_uniform_3f program "light_amb" light.ambient;
  ShaderProgram.bind_uniform_3f program "light_dif" light.diffuse;
  ShaderProgram.bind_uniform_3f program "light_spec" light.specular

let draw r model model_mat view_mat proj_mat =
  use r model_mat view_mat proj_mat;
  Model.draw r.program.gl model;
  ShaderProgram.stop r.program;
