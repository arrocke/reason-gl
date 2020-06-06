type t = (float array) array

let translation tx ty tz = [|
  [| 1.0; 0.0; 0.0; 0.0; |];
  [| 0.0; 1.0; 0.0; 0.0; |];
  [| 0.0; 0.0; 1.0; 0.0; |];
  [| tx ; ty ; tz ; 1.0 |];
|]

let xRotation t = 
  let c = cos t in
  let s = sin t in
  [|
    [| 1.0; 0.0; 0.0; 0.0; |];
    [| 0.0; c;   s;   0.0; |];
    [| 0.0; -.s; c;   0.0; |];
    [| 0.0; 0.0; 0.0; 1.0  |];
  |]

let yRotation t = 
  let c = cos t in
  let s = sin t in
  [|
    [| c;   0.0; -.s; 0.0; |];
    [| 0.0; 1.0; 0.0; 0.0; |];
    [| s;   0.0; c;   0.0; |];
    [| 0.0; 0.0; 0.0; 1.0  |];
  |]

let zRotation t = 
  let c = cos t in
  let s = sin t in
  [|
    [| c;   s;   0.0;   0.0; |];
    [| -.s; c  ; 0.0; 0.0; |];
    [| 0.0; 0.0; 1.0;   0.0; |];
    [| 0.0; 0.0; 0.0; 1.0  |];
  |]

let scaling sx sy sz = [|
  [| sx;  0.0; 0.0; 0.0; |];
  [| 0.0; sy;  0.0; 0.0; |];
  [| 0.0; 0.0; sz;  0.0; |];
  [| 0.0; 0.0; 0.0; 1.0 |];
|]

let multiply m1 m2 = 
  let entry m n =
    m1.(m).(0) *. m2.(0).(n) +.
    m1.(m).(1) *. m2.(1).(n) +.
    m1.(m).(2) *. m2.(2).(n) +.
    m1.(m).(3) *. m2.(3).(n) in
  [|
    [| (entry 0 0); (entry 0 1); (entry 0 2); (entry 0 3); |];
    [| (entry 1 0); (entry 1 1); (entry 1 2); (entry 1 3); |];
    [| (entry 2 0); (entry 2 1); (entry 2 2); (entry 2 3); |];
    [| (entry 3 0); (entry 3 1); (entry 3 2); (entry 3 3) |];
  |]

let multiply_vector mat (x, y, z) = 
  let entry m = mat.(m).(0) *. x +. mat.(m).(1) *. y +. mat.(m).(2) *. z in
  (entry 0), (entry 1), (entry 2)

let identity = [|
  [| 1.0; 0.0; 0.0; 0.0; |];
  [| 0.0; 1.0; 0.0; 0.0; |];
  [| 0.0; 0.0; 1.0; 0.0; |];
  [| 0.0; 0.0; 0.0; 1.0 |];
|]

let translate tx ty tz m = multiply (translation tx ty tz) m
let rotateX t m = multiply (xRotation t) m
let rotateY t m = multiply (yRotation t) m
let rotateZ t m = multiply (zRotation t) m
let scale sx sy sz m = multiply (scaling sx sy sz) m

let orthographic left right bottom top near far = [|
  [| (2. /. (right -. left)); 0.; 0.; 0.; |];
  [| 0.; (2. /. (top -. bottom)); 0.; 0.; |];
  [| 0.; 0.; (2. /. (near -. far)); 0.; |];
  [| (left +. right) /. (left -. right);
  (bottom +. top) /. (bottom -. top);
  (near +. far) /. (near -. far);
  1.; |];
|]

let perspective fov aspect near far =
  let f = tan (3.1415 *. 0.5 -. 0.5 *. fov) in
  let rangeInv = 1.0 /. (near -. far) in
  [|
    [| f /. aspect; 0.; 0.; 0.; |];
    [| 0.; f; 0.; 0.; |];
    [| 0.; 0.; (near +. far) *. rangeInv; -1.; |];
    [| 0.; 0.; near *. far *. rangeInv *. 2.; 0.; |];
  |]

let transpose mat =
  Array.mapi (fun m _ -> Array.mapi (fun n _ -> mat.(n).(m)) mat.(m)) mat

let inverse mat =
  let det m n =
    let mat2 = Array.make_matrix 3 3 0. in
    let rec process_row i1 i2 = match i1 with
    | i1 when i1 >= 4 -> ()
    | i1 when i1 = m -> process_row (i1 + 1) i2
    | i1 ->
      let rec process_col j1 j2 = match j1 with
        | j1 when j1 >= 4 -> process_row (i1 + 1) (i2 + 1)
        | j1 when j1 = n -> process_col (j1 + 1) j2 
        | j1 ->
          Array.set mat2.(i2) j2 mat.(i1).(j1);
          process_col (j1 + 1) (j2 + 1) in
      process_col 0 0 in
    process_row 0 0;
    mat2.(0).(0) *. (mat2.(1).(1) *. mat2.(2).(2) -. mat2.(1).(2) *. mat2.(2).(1)) -.
      mat2.(0).(1) *. (mat2.(1).(0) *. mat2.(2).(2) -. mat2.(1).(2) *. mat2.(2).(0)) +.
      mat2.(0).(2) *. (mat2.(1).(0) *. mat2.(2).(1) -. mat2.(1).(1) *. mat2.(2).(0)) in
  let adj = [|
    [| (det 0 0); -.(det 1 0); (det 2 0); -.(det 3 0); |];
    [| -.(det 0 1); (det 1 1); -.(det 2 1); (det 3 1); |];
    [| (det 0 2); -.(det 1 2); (det 2 2); -.(det 3 2); |];
    [| -.(det 0 3); (det 1 3); -.(det 2 3); (det 3 3); |];
  |] in
  let det4 = 1. /.
    (mat.(0).(0) *. adj.(0).(0) +.
     mat.(0).(1) *. adj.(1).(0) +.
     mat.(0).(2) *. adj.(2).(0) +.
     mat.(0).(3) *. adj.(3).(0)) in
  Array.map (Array.map (fun el -> el *. det4)) adj

let to_string mat =
  let el m n = Js.Float.toString mat.(m).(n) in
  let line m = String.concat "" [(el m 0); " "; (el m 1); " "; (el m 2); " "; (el m 3);] in
  String.concat "" [(line 0); "\n" ; (line 1); "\n"; (line 2); "\n"; (line 3)]

let to_float32array mat = (Array.fold_left (fun a row -> Array.append a row) [||] mat) |> Js.TypedArray2.Float32Array.make 