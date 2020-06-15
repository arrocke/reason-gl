type keyboard_event = {
  key: string
}

external add_event_listener: string -> (keyboard_event -> unit) -> unit = "addEventListener" [@@bs.val] [@@bs.scope "window"]

let gl = match GL.init () with
| Some(gl) -> gl
| None -> raise(Not_found)

let canvas = GL.canvas(gl)

let () = GL.enable gl GL.Constant.cull_face
let () = GL.enable gl GL.Constant.depth_test

let light = Light.create (Point3.create 500. 500. 500.) (Color.create_rgb 1.0 1.0 1.0)

let renderer = Renderer.init gl light

let model = Model.load gl (Sphere.create 50 100)

let scale len n = (mod_float n len) /. len

let loop state t =
  (* Reset canvas. *)
  GL.clear_color gl 1.0 1.0 1.0 1.0;
  GL.clear gl (GL.Constant.color_buffer_bit lor GL.Constant.depth_buffer_bit);
  let width = Canvas.width canvas in
  let height = Canvas.height canvas in
  GL.viewport gl 0.0 0.0 (width) (height);

  let aspect = width /. height in
  let proj_mat = Matrix4.perspective 1.0 aspect 1. 2000. in

  let view_mat =
    Matrix4.identity |>
    Matrix4.translate 0. 0. (500.) |>
    Matrix4.inverse in

  let model_mat =
    (Matrix4.translation 0. 0. 0.) |>
    (Matrix4.scale 100. 100. 100.) in

  Renderer.draw renderer model model_mat view_mat proj_mat;

  state

let () = RenderLoop.start loop ()
