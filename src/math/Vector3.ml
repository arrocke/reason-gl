type t = float * float * float

let magnitude (x, y, z) = sqrt (x *. x +. y *. y +. z *. z) 

let normalize v = 
  let m = magnitude v in
  let (x, y, z) = v in
  (x /. m, y /. m, z /. m)