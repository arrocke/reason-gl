module Float32Array = Js.TypedArray2.Float32Array
module Uint16Array = Js.TypedArray2.Uint16Array

type t = {
  vertices: float array;
  normals: float array;
  colors: float array;
  indices: int array;
  data_buffer: GL.buffer option;
  index_buffer: GL.buffer option;
  loaded: bool;
}

let create vertices = {
  vertices;
  normals = [||];
  colors = [||];
  indices = [||];
  data_buffer = None;
  index_buffer = None;
  loaded = false;
}

let set_normals normals model = {
  model with
  normals;
  loaded = false;
}

let set_indicies indices model = {
  model with
  indices;
  loaded = false;
}

let set_colors colors model = {
  model with
  colors;
  loaded = false;
}

let float_buffer_of_array arr = Float32Array.make arr |> Float32Array.buffer
let int_buffer_of_array arr = Uint16Array.make arr |> Uint16Array.buffer

let load gl model =
  let verticesSize = (Array.length model.vertices) * 4 in
  let verticesOffset = 0 in
  let normalsSize = (Array.length model.normals) * 4 in
  let normalsOffset = verticesOffset + verticesSize in
  let colorsSize = (Array.length model.colors) * 4 in
  let colorsOffset = normalsOffset + normalsSize in
  let totalSize = verticesSize + normalsSize + colorsSize in
  
  let data_buffer = match model.data_buffer with
  | Some(buffer) -> buffer
  | None -> GL.create_buffer gl in
  GL.bind_buffer gl GL.Constant.array_buffer data_buffer;
  GL.buffer_data_size gl GL.Constant.array_buffer totalSize GL.Constant.static_draw;

  GL.buffer_sub_data gl GL.Constant.array_buffer verticesOffset (float_buffer_of_array model.vertices);
  GL.enable_vertex_attrib_array gl 0;
  GL.vertex_attrib_pointer gl 0 3 GL.Constant.float false 0 verticesOffset;

  let () = match Array.length model.normals with
  | 0 -> GL.disable_vertex_attrib_array gl 1 
  | _ -> 
    GL.buffer_sub_data gl GL.Constant.array_buffer normalsOffset (float_buffer_of_array model.normals);
    GL.enable_vertex_attrib_array gl 1;
    GL.vertex_attrib_pointer gl 1 3 GL.Constant.float true 0 normalsOffset in

  let () = match Array.length model.colors with
  | 0 -> GL.disable_vertex_attrib_array gl 2 
  | _ -> 
    GL.buffer_sub_data gl GL.Constant.array_buffer colorsOffset (float_buffer_of_array model.colors);
    GL.enable_vertex_attrib_array gl 2;
    GL.vertex_attrib_pointer gl 2 3 GL.Constant.float true 0 colorsOffset in

  let index_buffer = match Array.length model.normals with
  | 0 -> None
  | _ -> 
    let index_buffer = match model.data_buffer with
    | Some(buffer) -> buffer
    | None -> GL.create_buffer gl in
    GL.bind_buffer gl GL.Constant.element_array_buffer index_buffer;
    GL.buffer_data gl GL.Constant.element_array_buffer (int_buffer_of_array model.indices) GL.Constant.static_draw;
    Some(index_buffer) in

  {
    model with
    data_buffer = Some(data_buffer);
    index_buffer;
    loaded = true
  }

let draw gl model =
  GL.vertex_attrib_3f gl 1 0. 0. 0.;
  GL.vertex_attrib_3f gl 2 1. 1. 1.;
  match Array.length model.indices with
  | 0 -> GL.draw_arrays gl GL.Constant.triangles 0 (Array.length model.vertices)
  | _ -> GL.draw_elements gl GL.Constant.triangles (Array.length model.indices) GL.Constant.ushort 0