@tool
class_name MapTransition extends Area2D

#region Variables
@export var id: int
@export var target_map: String
@export var target_id: int

@onready var entry: Node2D = $Entry
@onready var exit: CollisionShape2D = $Exit
#endregion

#region Signals
signal triggered(target_map_id, target_transition_id)
#endregion

#region Engine Functions
func _ready() -> void:
	if Engine.is_editor_hint():
		notify_property_list_changed()
		return
	assert(entry)
	assert(exit)
	area_entered.connect(_on_entered)
	body_entered.connect(_on_entered)

func _validate_property(property: Dictionary) -> void:
	if property.name == "target_map":
		property.hint = PROPERTY_HINT_ENUM
		property.hint_string = ",".join(Gameplay.get_map_names())
#endregion

#region Public Functions
#endregion

#region Private Functions
func _on_entered(node):
	if node is Player:
		triggered.emit(target_map, target_id)
#endregion

