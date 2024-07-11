@tool
class_name Destination extends Area2D

### Variables
@onready var collision: CollisionShape2D = $Collision
@onready var triggers = $Triggers

@export var selectable: bool = true:
	set(v):
		selectable = v
		_set_debug_color()

### Signals
signal selected

### Public Functions
func reach():
	for trigger in triggers.get_children():
		assert(trigger is Trigger, "Non-Trigger child found under destination triggers")
		print("Trigger: %s" % trigger.name)
		await trigger.execute()

### Engine Functions
func _ready():
	self.input_event.connect(_on_input_event)

### Private Functions
func _on_input_event(_v: Node, event: InputEvent, _i: int):
	if selectable and event is InputEventMouseButton and event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT] and event.is_released():
		selected.emit()

func _set_debug_color():
	if not collision:
		return
	if selectable:
		collision.debug_color = Color.hex(0x0099b36b)
	else:
		collision.debug_color = Color.hex(0xb300006b)
