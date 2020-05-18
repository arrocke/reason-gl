type t

let init: unit -> t option = [%raw {|
  function() {
    const canvas = document.createElement('canvas')
    document.body.append(canvas)
    return canvas.getContext('webgl')
  }
|}]

external clear_color: t -> float -> float -> float -> float -> unit = "clearColor" [@@bs.send]

external clear: t -> Constant.ClearBuffer.t -> unit = "clear" [@@bs.send]

external draw_arrays: t -> Constant.DrawMode.t -> int -> int -> unit = "drawArrays" [@@bs.send]
