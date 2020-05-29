module Float32Array = Js.TypedArray2.Float32Array

type t = {
  vertices: float array;
  normals: float array;
  buffer: GL.buffer option;
  loaded: bool;
}

let create vertices normals = {
  vertices;
  normals;
  buffer = None;
  loaded = false;
}

let array_buffer_of_array arr = Float32Array.make arr |> Float32Array.buffer

let load gl model =
  let verticesSize = (Array.length model.vertices) * 4 in
  let verticesOffset = 0 in
  let normalsSize = (Array.length model.normals) * 4 in
  let normalsOffset = verticesOffset + verticesSize in
  let totalSize = verticesSize + normalsSize in
  
  let buffer = match model.buffer with
  | Some(buffer) -> buffer
  | None -> GL.create_buffer gl in
  GL.bind_buffer gl GL.Constant.array_buffer buffer;
  GL.buffer_data_size gl GL.Constant.array_buffer totalSize GL.Constant.static_draw;

  GL.buffer_sub_data gl GL.Constant.array_buffer verticesOffset (array_buffer_of_array model.vertices);
  GL.enable_vertex_attrib_array gl 0;
  GL.vertex_attrib_pointer gl 0 3 GL.Constant.float false 0 verticesOffset;

  GL.buffer_sub_data gl GL.Constant.array_buffer normalsOffset (array_buffer_of_array model.normals);
  GL.enable_vertex_attrib_array gl 1;
  GL.vertex_attrib_pointer gl 1 3 GL.Constant.float false 0 normalsOffset;

  {
    model with
    buffer = Some(buffer);
    loaded = true
  }

let draw gl model =
  GL.draw_arrays gl GL.Constant.triangles 0 ((Array.length model.vertices) / 3);