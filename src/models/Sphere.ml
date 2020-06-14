let pi = 4.0 *. atan 1.0

let fold_i fn init n = 
  let rec iter i acc = match i with
  | i when i < n -> iter (i + 1) (fn i acc)
  | _ -> acc in
  iter 0 init

let create num_v num_h =
  let r = 1. in
  let v_step = pi /. float_of_int(num_v) in
  let h_step = 2. *. pi /. float_of_int(num_h) in
  let (vertices, normals) = fold_i (fun i acc ->
    let v_angle = v_step *. float_of_int(i) in
    let xz = r *. (sin v_angle) in
    let y = -.r *. (cos v_angle) in
    fold_i (fun j (vertices, normals) -> 
      let h_angle = h_step *. float_of_int(j) in
      let x = xz *. (cos h_angle) in
      let z = xz *. (sin h_angle) in
      (
        x::y::z::vertices,
        (x /. r)::(y /. r)::(z /. r)::normals
      )
    ) acc (num_h + 1)
  ) ([], []) (num_v + 1) in
  let indices = fold_i (fun i indices -> 
    let k1 = i * (num_h + 1) in
    let k2 = k1 + num_h + 1 in
    fold_i (fun j indices ->
      let k1 = k1 + j in
      let k2 = k2 + j in
      let indices = if i != 0 then (k1::k2::(k1 + 1)::indices) else indices in
      if i != (num_v - 1) then (k1 + 1)::k2::(k2 + 1)::indices else indices
    ) indices num_h
  ) [] num_v in
  Model.create (Array.of_list (List.rev vertices)) |>
  Model.set_normals (Array.of_list (List.rev normals)) |>
  Model.set_indicies (Array.of_list (List.rev indices))
  