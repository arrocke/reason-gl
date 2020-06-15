type frame_id

external request_frame : (float -> unit) -> frame_id = "requestAnimationFrame" [@@bs.val]

let start loop state = 
  let rec render_loop state t  =
    let new_state = loop state t in
    let _ = request_frame (render_loop new_state) in
    () in
  let _ = request_frame (render_loop state) in
  ()
