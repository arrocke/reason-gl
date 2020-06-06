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

let () = Renderer.init gl
let () = Renderer.set_light
  (Vector3.create 500. 500. 500.)
  (Vector3.create 0.8 0.2 0.5)
  (Vector3.create 0.8 0.2 0.5)
  (Vector3.create 0.8 0.2 0.5)
let model = Model.load gl (Sphere.create 50 100)

let scale len n = (mod_float n len) /. len

type state = {
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

let rec loop { r } t =
  let r = if !left_key_down then r +. 0.01 else r in
  let r = if !right_key_down then r -. 0.01 else r in

  (* Reset canvas. *)
  GL.clear_color gl 1.0 1.0 1.0 1.0;
  GL.clear gl (GL.Constant.color_buffer_bit lor GL.Constant.depth_buffer_bit);
  let width = Canvas.width canvas in
  let height = Canvas.height canvas in
  GL.viewport gl 0.0 0.0 (width) (height);

  let aspect = width /. height in
  let proj_mat = Matrix.perspective 1.0 aspect 1. 2000. in

  let view_mat =
    Matrix.identity |>
    Matrix.rotateY r |>
    Matrix.translate 0. 0. (500.) |>
    Matrix.inverse in

  let model_mat =
    (Matrix.translation 0. 0. 0.) |>
    (Matrix.scale 100. 100. 100.) in

  Renderer.draw model model_mat view_mat proj_mat;

  (* Request next frame *)
  let _ = request_frame (loop { r;}) in

  ()

let id = request_frame (loop { r = 3.14 })
