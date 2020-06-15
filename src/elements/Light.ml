type t = {
  position: Point3.t;
  ambient: Color.t;
  diffuse: Color.t;
  specular: Color.t;
}

let create position color = {
  position;
  ambient = color;
  diffuse = color;
  specular = color;
}

let position light = light.position
let ambient light = light.ambient
let diffuse light = light.diffuse
let specular light = light.specular