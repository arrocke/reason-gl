type t

val create: float -> float -> float -> t

val x: t -> float
val y: t -> float
val z: t -> float

val uniform_3: t -> float * float * float