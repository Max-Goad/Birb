class_name Math

#region Vectors
static func vector4dir(vector: Vector2) -> Vector2:
	if vector == Vector2.ZERO:
		return vector
	var ld = vector.distance_to(Vector2.LEFT)
	var rd = vector.distance_to(Vector2.RIGHT)
	var ud = vector.distance_to(Vector2.UP)
	var dd = vector.distance_to(Vector2.DOWN)
	match min(ld, rd, ud, dd):
		ld:
			return Vector2.LEFT
		rd:
			return Vector2.RIGHT
		ud:
			return Vector2.UP
		dd:
			return Vector2.DOWN
		_:
			return Vector2.ZERO

static func vector8dir(vector: Vector2) -> Vector2:
	if vector == Vector2.ZERO:
		return vector
	var vul = (Vector2.UP + Vector2.LEFT).normalized()
	var vur = (Vector2.UP + Vector2.RIGHT).normalized()
	var vdl = (Vector2.DOWN + Vector2.LEFT).normalized()
	var vdr = (Vector2.DOWN + Vector2.RIGHT).normalized()

	var ld = vector.distance_to(Vector2.LEFT)
	var rd = vector.distance_to(Vector2.RIGHT)
	var ud = vector.distance_to(Vector2.UP)
	var dd = vector.distance_to(Vector2.DOWN)
	var uld = vector.distance_to(vul)
	var urd = vector.distance_to(vur)
	var dld = vector.distance_to(vdl)
	var drd = vector.distance_to(vdr)
	match min(ld, rd, ud, dd, uld, urd, dld, drd):
		ld:
			return Vector2.LEFT
		rd:
			return Vector2.RIGHT
		ud:
			return Vector2.UP
		dd:
			return Vector2.DOWN
		uld:
			return vul
		urd:
			return vur
		dld:
			return vdl
		drd:
			return vdr
		_:
			return Vector2.ZERO
#endregion

#region Dither
static func dither_v_rot(v: Vector2, amount: float) -> Vector2:
	return v.rotated(randf_range(-amount/2, amount/2))

static func dither_v_pos(v: Vector2, amount: float) -> Vector2:
	return Vector2(v.x + randf_range(-amount/2, amount/2), v.y + randf_range(-amount/2, amount/2))

static func dither_f(f: float, amount: float) -> float:
	return f + randf_range(-amount/2, amount/2)

static func dither_c(c: Color, percent: float) -> Color:
	return Color(c.r + randf_range(-percent/2, percent/2),
				 c.g + randf_range(-percent/2, percent/2),
				 c.b  + randf_range(-percent/2, percent/2))
#endregion

#region Random
# Return one of the two values at random
static func rand_pick(v1: Variant, v2: Variant) -> Variant:
	return [v1, v2][randi() % 2]

# Return either the value or the negative of the value at random
static func rand_negative(v: Variant) -> Variant:
	return rand_pick(v, -v)
#endregion

#region Flags
static func flag_set(bitmask: int, position: int) -> int:
	assert(position < 32, "attempting to set a bit in position > 32")
	var out = bitmask | (1 << position)
	# print("Math: %s -> %s" % [flag_str(bitmask), flag_str(out)])
	return out

static func flag_unset(bitmask: int, position: int) -> int:
	assert(position < 32, "attempting to unset a bit in position > 32")
	return bitmask & ~(1 << position)

static func flag_is_set(bitmask: int, position: int) -> bool:
	var out = bool(bitmask & (1 << position))
	# print(flag_str(bitmask))
	# print("Math: pos %s set? %s" % [position, out])
	return out

static func flag_to_array(bitmask: int) -> Array[int]:
	var out: Array[int] = []
	for i in 32: # bits in an int
		if flag_is_set(bitmask, i):
			out.append(i)
	return out

static func flag_str(bitmask: int) -> String:
	var out: String = "0b"
	for i in 32: # bits in an int
		if bool(bitmask & (1 << i)): # can't use "flag_is_set" or stack overflow
			out += "1"
		else:
			out += "0"
	return out
#endregion
