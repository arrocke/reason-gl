type t

let init: unit -> t option = [%raw {|
  function() {
    const canvas = document.createElement('canvas')
    window.addEventListener('resize', () => {
      canvas.width = canvas.clientWidth
      canvas.height = canvas.clientHeight
    })
    document.body.append(canvas)
    canvas.width = canvas.clientWidth
    canvas.height = canvas.clientHeight
    return canvas.getContext('webgl')
  }
|}]

external canvas: t -> Canvas.t = "canvas" [@@bs.get]

external clear_color: t -> float -> float -> float -> float -> unit = "clearColor" [@@bs.send]

external clear: t -> Constant.ClearBuffer.t -> unit = "clear" [@@bs.send]

external viewport: t -> float -> float -> float -> float -> unit = "viewport" [@@bs.send]

external draw_arrays: t -> Constant.DrawMode.t -> int -> int -> unit = "drawArrays" [@@bs.send]
