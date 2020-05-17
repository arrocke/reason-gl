type t;

[@bs.send] external location : (GL.t, Program.t, string) => t = "getUniformLocation";
