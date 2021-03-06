type t = float * float * float

val create: float -> float -> float -> t

val x: t -> float
val y: t -> float
val z: t -> float

val magnitude: t -> float

val normalize: t -> t