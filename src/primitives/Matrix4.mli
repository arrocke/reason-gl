type t

val identity: t
val multiply: t -> t -> t
val multiply_vector: t -> Vector3.t -> Vector3.t
val transpose: t -> t
val inverse: t -> t

val to_string: t -> string
val to_float32array: t -> Js.TypedArray2.Float32Array.t

val translation: float -> float -> float -> t
val xRotation: float -> t
val yRotation: float -> t
val zRotation: float -> t
val scaling: float -> float -> float -> t

val translate: float -> float -> float -> t -> t
val rotateX: float -> t -> t
val rotateY: float -> t -> t
val rotateZ: float -> t -> t
val scale: float -> float -> float -> t -> t

val orthographic: float -> float -> float -> float -> float -> float -> t
val perspective: float -> float -> float -> float -> t