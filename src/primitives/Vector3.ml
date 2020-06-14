type t = float * float * float

let create x y z = (x, y, z)

let x (_x, _, _) = _x
let y (_, _y, _) = _y
let z (_, _, _z) = _z

let magnitude (x, y, z) = sqrt (x *. x +. y *. y +. z *. z) 

let normalize v = 
  let m = magnitude v in
  let (x, y, z) = v in
  (x /. m, y /. m, z /. m)