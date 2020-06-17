type t = float * float * float * float

val create_rgb: float -> float -> float -> t
val create_rgba: float -> float -> float -> float -> t

val tuple_3: t -> float * float * float
val tuple_4: t -> float * float * float * float