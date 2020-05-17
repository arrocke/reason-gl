type canvas = Dom.element;
type t;

[@bs.val] [@bs.scope "document"] external query_canvas : (string) => canvas = "querySelector";
[@bs.send] external init_GL : (canvas, [@bs.as "webgl"] _) => option(t) = "getContext";

[@bs.send] external clear_color : (t, float, float, float, float) => unit = "clearColor";

[@bs.send] external clear : (t, Constant.ClearBuffer.t) => unit = "clear";

[@bs.send] external draw_arrays : (t, Constant.DrawMode.t, int, int) => unit = "drawArrays";
