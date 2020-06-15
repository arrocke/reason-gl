type t = float * float * float

let create x y z = x, y, z

let x (_x, _, _) = _x
let y (_, _y, _) = _y
let z (_, _, _z) = _z

let uniform_3 p = p