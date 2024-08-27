class_name VFXRiver extends TextureRect

const WATER_HORIZONTAL: ShaderMaterial = preload("res://resources/shaders/water_horizontal.tres")
const WATER_VERTICAL = preload("res://resources/shaders/water_vertical.tres")

@export var fade_time = 1.0
@export var flow_speed = Vector2.ZERO:
	set(value):
		flow_speed = value
		WATER_HORIZONTAL.set_shader_parameter("speed", flow_speed)
		WATER_VERTICAL.set_shader_parameter("speed", flow_speed)
@export var horizontal = true

var _tween: Tween

func _ready() -> void:
	self.texture = NoiseTexture2D.new()
	self.set_anchors_preset(Control.PRESET_FULL_RECT, true)
	if horizontal:
		self.material = WATER_HORIZONTAL
	else:
		self.material = WATER_VERTICAL
	self.modulate.a = 0.0
	_tween = create_tween().set_trans(Tween.TRANS_CIRC)
	_tween.tween_property(self, "modulate:a", 0.75, 1*fade_time/4).set_ease(Tween.EASE_IN)
	_tween.tween_property(self, "modulate:a", 0.0, 3*fade_time/4).set_ease(Tween.EASE_OUT)
	_tween.tween_callback(queue_free)
