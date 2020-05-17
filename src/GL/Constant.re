module DataType {
  type t = int;

  let byte = 0x1400;
  let ubyte = 0x1401;
  let short = 0x1402;
  let ushort = 0x1403;
  let int = 0x1404;
  let uint = 0x1405;
  let float = 0x1406;
}

module BufferTarget {
  type t = int;

  let array = 0x8892;
  let element_array = 0x8893;
}

module BufferUsage {
  type t = int;

  let static = 0x88E4;
  let stream = 0x88E0;
  let dynamic = 0x88E8;
}

module ClearBuffer {
  type t = int;

  let depth = 0x00000100;
  let stencil = 0x00000400;
  let color = 0x00004000;

  let combine = List.fold_left((res, mask) => mask lor res, 0)
}

module DrawMode {
  type t = int;

  let points = 0x0000;
  let lines = 0x0001;
  let line_loop = 0x0002;
  let line_strip = 0x0003;
  let triangles = 0x0004;
  let triangle_strip = 0x0005;
  let triangle_fan = 0x0006;
}

module ShaderType {
  type t = int;

  let fragment = 0x8B30;
  let vertex = 0x8B31;
}