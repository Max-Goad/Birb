@tool
class_name VectorVisualizer extends Node2D

enum Mode
{
	ONE_VECTOR = 0,
	TWO_POSITIONS,
}

### Variables
@onready var body: CollisionShape2D = $Body
@onready var arrow: CollisionShape2D = $Arrow


@export var mode: Mode :
	set(value):
		mode = value
		notify_property_list_changed()
@export var origin: Node2D
@export var target: Node2D
@export var vector_name: String = "velocity"
@export var debug_color: Color = Color(1.0, 1.0, 1.0, 0.41)

### Signals

### Engine Functions
func _ready() -> void:
	assert(body and arrow)
	body.debug_color = debug_color
	arrow.debug_color = debug_color

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	var arrow_vector = Vector2.ZERO
	if mode == Mode.ONE_VECTOR:
		arrow_vector = origin.get(vector_name)
	else:
		arrow_vector = (target.global_position - origin.global_position)
	if visible:
		if arrow_vector == Vector2.ZERO:
			hide()
	else:
		if arrow_vector != Vector2.ZERO:
			show()
	self.rotation = arrow_vector.angle()

### Public Functions

### Private Functions
func _validate_property(property: Dictionary) -> void:
	if mode == Mode.ONE_VECTOR:
		if property.name == "target":
			property.usage &= ~PROPERTY_USAGE_EDITOR
	if mode == Mode.TWO_POSITIONS:
		if property.name == "vector_name":
			property.usage &= ~PROPERTY_USAGE_EDITOR
