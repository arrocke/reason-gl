type t = float * float * float * float

let create_rgb r g b = r, g, b, 1.
let create_rgba r g b a = r, g, b, a

let uniform_3 (r, g, b, _) = (r, g, b)
let uniform_4 c = c