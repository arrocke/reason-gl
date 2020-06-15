type t

val create_rgb: float -> float -> float -> t
val create_rgba: float -> float -> float -> float -> t

val uniform_3: t -> float * float * float
val uniform_4: t -> float * float * float * float