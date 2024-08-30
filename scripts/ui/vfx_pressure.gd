class_name VFXPressure extends ColorRect

const SHOCKWAVE: ShaderMaterial = preload("res://resources/shaders/shockwave.tres")

@export var center = Vector2.ZERO
@export var duration := 1.0

var _tween: Tween

func _ready() -> void:
	self.set_anchors_preset(Control.PRESET_FULL_RECT, true)
	self.material = SHOCKWAVE
	print(center)
	print(get_window().size)
	print(_convert_to_uv_coords(center))
	SHOCKWAVE.set_shader_parameter("center", _convert_to_uv_coords(center))
	# self.modulate.a = 0.0
	# TODO: What kind of transitions do we want
	_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	_tween.tween_method(set_wave_size, 0.0, 1.0, duration)
	_tween.tween_callback(queue_free)

func set_wave_size(value: float):
	SHOCKWAVE.set_shader_parameter("size", value)
	SHOCKWAVE.set_shader_parameter("thickness", 0.05 + (0.15 * value))

func _convert_to_uv_coords(vector: Vector2) -> Vector2:
	var window_size: Vector2 = get_window().size
	return Vector2(vector.x / window_size.x, vector.y / window_size.y)
