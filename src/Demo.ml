type frame_id
type keyboard_event = {
  key: string
}

external request_frame : (float -> unit) -> frame_id = "requestAnimationFrame" [@@bs.val]
external add_event_listener: string -> (keyboard_event -> unit) -> unit = "addEventListener" [@@bs.val] [@@bs.scope "window"]

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

type state = {
  x: float;
  z: float;
  r: float;
}

let left_key_down = ref false
let right_key_down = ref false
let up_key_down = ref false
let down_key_down = ref false

let () = add_event_listener "keydown" (fun e ->
  match e.key with
  | "ArrowLeft" -> left_key_down := true
  | "ArrowRight" -> right_key_down := true
  | "ArrowUp" -> up_key_down := true
  | "ArrowDown" -> down_key_down := true
  | _ -> ()
)

let () = add_event_listener "keyup" (fun e ->
  match e.key with
  | "ArrowLeft" -> left_key_down := false
  | "ArrowRight" -> right_key_down := false
  | "ArrowUp" -> up_key_down := false
  | "ArrowDown" -> down_key_down := false
  | _ -> ()
)

let rec loop { z; x; r} t =
  let r = if !left_key_down then r +. 0.01 else r in
  let r = if !right_key_down then r -. 0.01 else r in
  let (x, z) = if !up_key_down then (x -. ((sin r) *. 1.), z -. ((cos r) *. 1.)) else (x, z) in
  let (x, z) = if !down_key_down then (x +. ((sin r) *. 1.), z +. ((cos r) *. 1.)) else (x, z) in

  (* Reset canvas. *)
  GL.clear_color gl 0.0 0.0 0.0 1.0;
  GL.clear gl (GL.Constant.color_buffer_bit lor GL.Constant.depth_buffer_bit);
  let width = Canvas.width canvas in
  let height = Canvas.height canvas in
  GL.viewport gl 0.0 0.0 (width) (height);

  let aspect = width /. height in
  let projection = Matrix.perspective 1.0 aspect 1. 2000. in

  let camera =
    (Matrix.translation x 0. z) |>
    (Matrix.rotateY r) in 
  let view = Matrix.inverse camera in

  let transform =
    projection |>
    (Matrix.multiply view) |>
    (Matrix.translate 0. 0. 0.) |>
    (Matrix.rotateX 0.2) |>
    (Matrix.rotateZ 0.5) |>
    (Matrix.translate (-.50.) (-.75.0) (-.15.)) in

  (* Load program and initialize uniforms. *)
  GL.use_program gl program;
  GL.uniform_matrix_4fv gl u_matrix false (Matrix.to_float32array transform);

  FModel.draw gl model;

  (* Request next frame *)
  let _ = request_frame (loop { x; z; r;}) in

  ()

let id = request_frame (loop { x = 0.; z = -.500.; r = 3.14 })
