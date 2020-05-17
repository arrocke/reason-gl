module DataType {
  type t;

  let byte: t;
  let ubyte: t;
  let short: t;
  let ushort: t;
  let int: t;
  let uint: t;
  let float: t;
}

module BufferTarget {
  type t;

  let array: t;
  let element_array: t;
}

module BufferUsage {
  type t;

  let static: t;
  let stream: t;
  let dynamic: t;
}

module ClearBuffer {
  type t;

  let depth: t;
  let stencil: t;
  let color: t;

  let combine: (list(t)) => t;
}

module DrawMode {
  type t;

  let points: t;
  let lines: t;
  let line_loop: t;
  let line_strip: t;
  let triangles: t;
  let triangle_strip: t;
  let triangle_fan: t;
}

module ShaderType {
  type t = int;

  let fragment: t;
  let vertex: t;
}