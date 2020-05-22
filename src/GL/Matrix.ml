type t = float array

let translation tx ty tz = [|
  1.0; 0.0; 0.0; 0.0;
  0.0; 1.0; 0.0; 0.0;
  0.0; 0.0; 1.0; 0.0;
  tx ; ty ; tz ; 1.0
|]

let xRotation t = 
  let c = cos t in
  let s = sin t in
  [|
    1.0; 0.0; 0.0; 0.0;
    0.0; c;   s;   0.0;
    0.0; -.s; c;   0.0;
    0.0; 0.0; 0.0; 1.0 
  |]

let yRotation t = 
  let c = cos t in
  let s = sin t in
  [|
    c;   0.0; -.s; 0.0;
    0.0; 1.0; 0.0; 0.0;
    s;   0.0; c;   0.0;
    0.0; 0.0; 0.0; 1.0 
  |]

let zRotation t = 
  let c = cos t in
  let s = sin t in
  [|
    c;   s;   0.0;   0.0;
    -.s; c  ; 0.0; 0.0;
    0.0; 0.0; 1.0;   0.0;
    0.0; 0.0; 0.0; 1.0 
  |]

let scaling sx sy sz = [|
  sx;  0.0; 0.0; 0.0;
  0.0; sy;  0.0; 0.0;
  0.0; 0.0; sz;  0.0;
  0.0; 0.0; 0.0; 1.0
|]

let multiply m1 m2 = 
  let entry n m = m1.(n) *. m2.(m) +. m1.(n + 1) *. m2.(4 + m) +. m1.(n + 2) *. m2.(8 + m) +. m1.(n + 3) *. m2.(12 + m) in
  [|
    (entry 0 0); (entry 0 1); (entry 0 2); (entry 0 3);
    (entry 1 0); (entry 1 1); (entry 1 2); (entry 1 3);
    (entry 2 0); (entry 2 1); (entry 2 2); (entry 2 3);
    (entry 3 0); (entry 3 1); (entry 3 2); (entry 3 3)
  |]

let identity = [|
  1.0; 0.0; 0.0; 0.0;
  0.0; 1.0; 0.0; 0.0;
  0.0; 0.0; 1.0; 0.0;
  0.0; 0.0; 0.0; 1.0
|]

let translate tx ty tz m = multiply (translation tx ty tz) m
let rotateX t m = multiply (xRotation t) m
let rotateY t m = multiply (xRotation t) m
let rotateZ t m = multiply (xRotation t) m
let scale sx sy sz m = multiply (scaling sx sy sz) m

let to_float32array = Js.TypedArray2.Float32Array.make