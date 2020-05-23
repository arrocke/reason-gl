type frame_id

external request_frame : (float -> unit) -> frame_id = "requestAnimationFrame" [@@bs.val]

let gl = match GL.init () with
| Some(gl) -> gl
| None -> raise(Not_found)

let canvas = GL.canvas(gl)

let () = GL.enable gl GL.Constant.cull_face
let () = GL.enable gl GL.Constant.depth_test

exception InvalidShader
exception InvalidProgram

let build_program vertex_source fragment_source =
  let build_shader shader_type source = 
    let shader = GL.create_shader gl shader_type in
    let () = GL.shader_source gl shader source in
    let () = GL.compile_shader gl shader in
    match GL.get_shader_parameter gl shader GL.Constant.compile_status with
    | true -> shader
    | false ->
        GL.delete_shader gl shader;
        Js.log (GL.get_shader_info_log gl shader);
        raise InvalidShader in
  let vertex_shader = build_shader GL.Constant.vertex_shader vertex_source in
  let fragment_shader = build_shader GL.Constant.fragment_shader fragment_source in
  let program = GL.create_program(gl) in
  GL.attach_shader gl program vertex_shader;
  GL.attach_shader gl program fragment_shader;
  GL.link_program gl program;
  match GL.get_program_parameter gl program GL.Constant.link_status with
  | true -> program
  | false ->
      GL.delete_program gl program;
      raise InvalidProgram

let program = build_program Vertex.source Fragment.source

module Float32Array = Js.TypedArray2.Float32Array


let model = FModel.create gl

(* Get attribute and uniform locations. *)
let a_position = GL.get_attrib_location gl program "a_position"
let a_color = GL.get_attrib_location gl program "a_color"
let u_matrix = GL.get_uniform_location gl program "u_matrix"

(* Configure position attribute. *)
let () = GL.enable_vertex_attrib_array gl a_position
let () = GL.vertex_attrib_pointer gl a_position 3 GL.Constant.float false 16 0

(* Configure color attribute. *)
let () = GL.enable_vertex_attrib_array gl a_color
let () = GL.vertex_attrib_pointer gl a_color 3 GL.Constant.ubyte true 16 12

let scale len n = (mod_float n len) /. len

let transform x y z tx ty tz m = m |> (Matrix.translate x y z) |> (Matrix.rotateX tx) |> (Matrix.rotateY ty) |> (Matrix.rotateZ tz)

let rec loop t =
  (* Js.log2 "Time: " t; *)

  (* Reset canvas. *)
  GL.clear_color gl 0.0 0.0 0.0 1.0;
  GL.clear gl (GL.Constant.color_buffer_bit lor GL.Constant.depth_buffer_bit);
  let width = Canvas.width canvas in
  let height = Canvas.height canvas in
  GL.viewport gl 0.0 0.0 (width) (height);

  let projection = Matrix.orthographic 0. width height 0. 400. (-.400.) in

  (* Load program and initialize uniforms. *)
  GL.use_program gl program;
  let mat = projection |> (transform 300. 300. 50. (-.0.5) 0.5 1.2) in
  (* let mat = projection |> (Matrix.translate ((2.0 *. (scale 4000.0 t)) -. 1.0) 0.0 0.0) in *)
  GL.uniform_matrix_4fv gl u_matrix false (Matrix.to_float32array mat);

  FModel.draw gl model;

  (* Request next frame *)
  let _ = request_frame loop in

  ()

let id = request_frame loop
