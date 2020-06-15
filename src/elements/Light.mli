type t

val create: Point3.t -> Color.t -> t

val position: t -> Point3.t
val ambient: t -> Color.t
val diffuse: t -> Color.t
val specular: t -> Color.t