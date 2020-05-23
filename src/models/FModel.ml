module Float32Array = Js.TypedArray2.Float32Array
let vertices = [|
  (* left column front *)
 30.;   0.;  0.;
  0.;   0.;  0.;
  0.; 150.;  0.;
 30.;   0.;  0.;
  0.; 150.;  0.;
 30.; 150.;  0.;

(* top rung front *)
 30.;   0.;  0.;
 30.;  30.;  0.;
100.;   0.;  0.;
100.;   0.;  0.;
 30.;  30.;  0.;
100.;  30.;  0.;

(* middle rung front *)
 30.;  60.;  0.;
 30.;  90.;  0.;
 67.;  60.;  0.;
 67.;  60.;  0.;
 30.;  90.;  0.;
 67.;  90.;  0.;

(* left column back *)
  0.;   0.;  30.;
 30.;   0.;  30.;
  0.; 150.;  30.;
  0.; 150.;  30.;
 30.;   0.;  30.;
 30.; 150.;  30.;

 (* top rung back *)
 30.;   0.;  30.;
  100.;   0.;  30.;
   30.;  30.;  30.;
   30.;  30.;  30.;
  100.;   0.;  30.;
  100.;  30.;  30.;

  (* middle rung back *)
   30.;  60.;  30.;
   67.;  60.;  30.;
   30.;  90.;  30.;
   30.;  90.;  30.;
   67.;  60.;  30.;
   67.;  90.;  30.;

  (* top *)
    0.;   0.;   0.;
  100.;   0.;   0.;
  100.;   0.;  30.;
    0.;   0.;   0.;
  100.;   0.;  30.;
    0.;   0.;  30.;

  (* top rung right *)
  100.;   0.;   0.;
  100.;  30.;   0.;
  100.;  30.;  30.;
  100.;   0.;   0.;
  100.;  30.;  30.;
  100.;   0.;  30.;

  (* under top rung *)
  30.;   30.;   0.;
  30.;   30.;  30.;
  100.;  30.;  30.;
  30.;   30.;   0.;
  100.;  30.;  30.;
  100.;  30.;   0.;

  (* between top rung and middle *)
  30.;   30.;   0.;
  30.;   60.;  30.;
  30.;   30.;  30.;
  30.;   60.;  30.;
  30.;   30.;   0.;
  30.;   60.;   0.;

  (* top of middle rung *)
  30.;   60.;  30.;
  30.;   60.;   0.;
  67.;   60.;  30.;
  67.;   60.;  30.;
  30.;   60.;   0.;
  67.;   60.;   0.;

  (* right of middle rung *)
  67.;   60.;  30.;
  67.;   60.;   0.;
  67.;   90.;  30.;
  67.;   90.;  30.;
  67.;   60.;   0.;
  67.;   90.;   0.;

  (* bottom of middle rung. *)
  30.;   90.;   0.;
  30.;   90.;  30.;
  67.;   90.;  30.;
  30.;   90.;   0.;
  67.;   90.;  30.;
  67.;   90.;   0.;

  (* right of bottom *)
  30.;   90.;   0.;
  30.;  150.;  30.;
  30.;   90.;  30.;
  30.;  150.;  30.;
  30.;   90.;   0.;
  30.;  150.;   0.;

  (* bottom *)
  0.;   150.;   0.;
  0.;   150.;  30.;
  30.;  150.;  30.;
  0.;   150.;   0.;
  30.;  150.;  30.;
  30.;  150.;   0.;

  (* left side *)
  0.;   0.;   0.;
  0.;   0.;  30.;
  0.; 150.;  30.;
  0.;   0.;   0.;
  0.; 150.;  30.;
  0.; 150.;   0.;
|]

let colors = [|
  200;  70; 120;
  200;  70; 120;
  200;  70; 120;
   80;  70; 120;
   80;  70; 120;
   80;  70; 120;
   70;  200; 210;
   70;  200; 210;
   210; 100; 70;
   210; 160; 70;
   70; 180; 210;
   100; 70; 210;
   76; 210; 100;
   140; 210; 80;
   90; 130; 210;
   160; 160; 220;
|]


module ArrayBuffer = Js.TypedArray2.ArrayBuffer
module DataView = Js.TypedArray2.DataView

let vertex_count =  (Array.length vertices) / 3
let data = ArrayBuffer.make (16 * vertex_count)
let view = DataView.make data
let rec fill n = match n with
| n when n < vertex_count ->
  DataView.setFloat32LittleEndian view (16 * n) vertices.(3 * n);
  DataView.setFloat32LittleEndian view (16 * n + 4) vertices.(3 * n + 1);
  DataView.setFloat32LittleEndian view (16 * n + 8) vertices.(3 * n + 2);
  DataView.setUint8 view (16 * n + 12) colors.(3 * (n / 6));
  DataView.setUint8 view (16 * n + 13) colors.(3 * (n / 6) + 1);
  DataView.setUint8 view (16 * n + 14) colors.(3 * (n / 6) + 2);
  fill (n + 1)
| _ -> ()
let () = fill 0

let create gl =
  (* Initialize buffers. *)
  let buffer = GL.create_buffer gl in
  GL.bind_buffer gl GL.Constant.array_buffer buffer;
  GL.buffer_data gl GL.Constant.array_buffer data GL.Constant.static_draw;
  buffer

let draw gl buffer =
  (* Use position buffer to draw. *)
  GL.bind_buffer gl GL.Constant.array_buffer buffer;
  GL.draw_arrays gl GL.Constant.triangles 0 (vertex_count);
  ()