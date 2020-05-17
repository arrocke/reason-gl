type t;

[@bs.send] external location : (GL.t, Program.t, string) => t = "getAttribLocation";
[@bs.send] external vertex_pointer : (GL.t, t, int, Constant.DataType.t, bool, int, int) => unit = "vertexAttribPointer";
[@bs.send] external enable_vertex_array : (GL.t, t) => unit = "enableVertexAttribArray";