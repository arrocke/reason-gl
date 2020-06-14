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

let renderer = Renderer.init gl
let renderer = Renderer.set_light
  renderer
  (Vector3.create 500. 500. 500.)
  (Vector3.create 1.0 1.0 1.0)
  (Vector3.create 1.0 1.0 1.0)
  (Vector3.create 1.0 1.0 1.0)
let model = Model.load gl (Sphere.create 50 100)

let scale len n = (mod_float n len) /. len

let rec loop _ _ =
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
    Matrix.translate 0. 0. (500.) |>
    Matrix.inverse in

  let model_mat =
    (Matrix.translation 0. 0. 0.) |>
    (Matrix.scale 100. 100. 100.) in

  Renderer.draw renderer model model_mat view_mat proj_mat;

  (* Request next frame *)
  let _ = request_frame (loop ()) in

  ()

let id = request_frame (loop ())
