module Float32Array = Js.TypedArray2.Float32Array
module Uint16Array = Js.TypedArray2.Uint16Array

type t = {
  vertices: float array;
  normals: float array;
  indices: int array;
  data_buffer: GL.buffer option;
  index_buffer: GL.buffer option;
  loaded: bool;
}

let create vertices normals indices = {
    vertices;
    normals;
    indices;
    data_buffer = None;
    index_buffer = None;
    loaded = false;
  }

let float_buffer_of_array arr = Float32Array.make arr |> Float32Array.buffer
let int_buffer_of_array arr = Uint16Array.make arr |> Uint16Array.buffer

let load gl model =
  let verticesSize = (Array.length model.vertices) * 4 in
  let verticesOffset = 0 in
  let normalsSize = (Array.length model.normals) * 4 in
  let normalsOffset = verticesOffset + verticesSize in
  let totalSize = verticesSize + normalsSize in
  
  let data_buffer = match model.data_buffer with
  | Some(buffer) -> buffer
  | None -> GL.create_buffer gl in
  GL.bind_buffer gl GL.Constant.array_buffer data_buffer;
  GL.buffer_data_size gl GL.Constant.array_buffer totalSize GL.Constant.static_draw;

  GL.buffer_sub_data gl GL.Constant.array_buffer verticesOffset (float_buffer_of_array model.vertices);
  GL.enable_vertex_attrib_array gl 0;
  GL.vertex_attrib_pointer gl 0 3 GL.Constant.float false 0 verticesOffset;

  GL.buffer_sub_data gl GL.Constant.array_buffer normalsOffset (float_buffer_of_array model.normals);
  GL.enable_vertex_attrib_array gl 1;
  GL.vertex_attrib_pointer gl 1 3 GL.Constant.float false 0 normalsOffset;

  let index_buffer = match model.data_buffer with
  | Some(buffer) -> buffer
  | None -> GL.create_buffer gl in
  GL.bind_buffer gl GL.Constant.element_array_buffer index_buffer;
  GL.buffer_data gl GL.Constant.element_array_buffer (int_buffer_of_array model.indices) GL.Constant.static_draw;

  {
    model with
    data_buffer = Some(data_buffer);
    index_buffer = Some(index_buffer);
    loaded = true
  }

let draw gl model =
  GL.draw_elements gl GL.Constant.triangles (Array.length model.indices) GL.Constant.ushort 0;